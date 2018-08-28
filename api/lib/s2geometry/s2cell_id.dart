// Copyright 2005 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS-IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// Ported from C++ s2geometry library by:
// Jan Boon <kaetemi@no-break.space>

import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

import 's2coords.dart';
import 's2coords_internal.dart';
import 's2point.dart';
export 's2point.dart';

// from bits.h, bits.cc
int log2Floor(int n) {
  if (n == 0) return -1;
  int log = 0;
  int value = n;
  for (int i = 4; i >= 0; --i) {
    int shift = (1 << i);
    int x = value >> shift;
    if (x != 0) {
      value = x;
      log += shift;
    }
  }
  assert(value == 1);
  return log;
}

int log2FloorNonZero64(int n) {
  int topbits = (n >> 32) & 0xFFFFFFFF;
  if (topbits == 0) {
    // Top bits are zero, so scan in bottom bits
    return log2Floor(n & 0xFFFFFFFF);
  } else {
    return 32 + log2Floor(topbits);
  }
}

int findMSBSetNonZero64(int n) {
  return log2FloorNonZero64(n);
}

int findLSBSetNonZero(int n) {
  int rc = 31;
  for (int i = 4, shift = 1 << 4; i >= 0; --i) {
    int x = n << shift;
    if (x != 0) {
      n = x;
      rc -= shift;
    }
    shift >>= 1;
  }
  return rc;
}

int findLSBSetNonZero64(int n) {
  int bottombits = n & 0xFFFFFFFF;
  if (bottombits == 0) {
    // Bottom bits are zero, so scan in top bits
    return 32 + findLSBSetNonZero((n >> 32) & 0xFFFFFFFF);
  } else {
    return findLSBSetNonZero(bottombits);
  }
}

const int _kFaceBits = 3;
const int _kNumFaces = 6;
const int _kMaxLevel = kMaxCellLevel; // Valid levels: 0..kMaxLevel
const int _kPosBits = 2 * _kMaxLevel + 1;
const int _kMaxSize = 1 << _kMaxLevel;

const int _kLookupBits = 4;
Uint16List _lookup_pos = new Uint16List(1 << (2 * _kLookupBits + 2));
Uint16List _lookup_ij = new Uint16List(1 << (2 * _kLookupBits + 2));

void _initLookupCell(
    int level, int i, int j, int orig_orientation, int pos, int orientation) {
  if (level == _kLookupBits) {
    int ij = (i << _kLookupBits) + j;
    _lookup_pos[(ij << 2) + orig_orientation] = (pos << 2) + orientation;
    _lookup_ij[(pos << 2) + orig_orientation] = (ij << 2) + orientation;
  } else {
    level++;
    i <<= 1;
    j <<= 1;
    pos <<= 2;
    List<int> r = kPosToIJ[orientation];
    _initLookupCell(level, i + (r[0] >> 1), j + (r[0] & 1), orig_orientation,
        pos, orientation ^ kPosToOrientation[0]);
    _initLookupCell(level, i + (r[1] >> 1), j + (r[1] & 1), orig_orientation,
        pos + 1, orientation ^ kPosToOrientation[1]);
    _initLookupCell(level, i + (r[2] >> 1), j + (r[2] & 1), orig_orientation,
        pos + 2, orientation ^ kPosToOrientation[2]);
    _initLookupCell(level, i + (r[3] >> 1), j + (r[3] & 1), orig_orientation,
        pos + 3, orientation ^ kPosToOrientation[3]);
  }
}

bool _flag = false;
void _maybeInit() {
  if (!_flag) {
    _flag = true;
    _initLookupCell(0, 0, 0, 0, 0, 0);
    _initLookupCell(0, 0, 0, kSwapMask, 0, kSwapMask);
    _initLookupCell(0, 0, 0, kInvertMask, 0, kInvertMask);
    _initLookupCell(
        0, 0, 0, kSwapMask | kInvertMask, 0, kSwapMask | kInvertMask);
  }
}

// need s2sphere.RegionCoverer

class S2CellId {
  S2CellId(this._id);

  S2CellId.fromPoint(S2Point p) {
    S2FaceUV faceUv = xyzToFaceUV(p);
    int i = stToIJ(uvToST(faceUv.uv.u));
    int j = stToIJ(uvToST(faceUv.uv.v));
    _id = new S2CellId.fromFaceIJ(faceUv.face, i, j).id;
  }

  S2CellId.fromFaceIJ(int face, int i, int j) {
    // Initialization if not done yet
    _maybeInit();

    // Optimization notes:
    //  - Non-overlapping bit fields can be combined with either "+" or "|".
    //    Generally "+" seems to produce better code, but not always.

    // Note that this value gets shifted one bit to the left at the end
    // of the function.
    int n = face << (_kPosBits - 1);

    // Alternating faces have opposite Hilbert curve orientations; this
    // is necessary in order for all faces to have a right-handed
    // coordinate system.
    int bits = (face & kSwapMask);

    // Each iteration maps 4 bits of "i" and "j" into 8 bits of the Hilbert
    // curve position.  The lookup table transforms a 10-bit key of the form
    // "iiiijjjjoo" to a 10-bit value of the form "ppppppppoo", where the
    // letters [ijpo] denote bits of "i", "j", Hilbert curve position, and
    // Hilbert curve orientation respectively.
    var getBits = (int k) {
      const int mask = (1 << _kLookupBits) - 1;
      bits += ((i >> (k * _kLookupBits)) & mask) << (_kLookupBits + 2);
      bits += ((j >> (k * _kLookupBits)) & mask) << 2;
      bits = _lookup_pos[bits];
      n |= (bits >> 2) << (k * 2 * _kLookupBits);
      bits &= (kSwapMask | kInvertMask);
    };

    getBits(7);
    getBits(6);
    getBits(5);
    getBits(4);
    getBits(3);
    getBits(2);
    getBits(1);
    getBits(0);

    _id = n * 2 + 1;
  }

  // Print the num_digits low order hex digits.
  String hexFormatString(int val, int numDigits) {
    StringBuffer result = new StringBuffer(); // (numDigits, ' ');
    for (; numDigits-- > 0; val >>= 4)
      result.write("0123456789abcdef"[val & 0xF]);
    return result.toString();
  }

  String toToken() {
    // Simple implementation: print the id in hex without trailing zeros.
    // Using hex has the advantage that the tokens are case-insensitive, all
    // characters are alphanumeric, no characters require any special escaping
    // in queries for most indexing systems, and it's easy to compare cell
    // tokens against the feature ids of the corresponding features.
    //
    // Using base 64 would produce slightly shorter tokens, but for typical cell
    // sizes used during indexing (up to level 15 or so) the average savings
    // would be less than 2 bytes per cell which doesn't seem worth it.

    // "0" with trailing 0s stripped is the empty string, which is not a
    // reasonable token.  Encode as "X".
    if (_id == 0) return "X";
    int numZeroDigits = findLSBSetNonZero64(_id) ~/ 4;
    int shift = (4 * numZeroDigits);
    return hexFormatString(
        (_id >> shift) & ((1 << (64 - shift)) - 1), 16 - numZeroDigits);
  }

  int get id {
    return _id;
  }

  int _id = 0;
}
