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

import 'dart:math';

import 's1angle.dart';
import 's2point.dart';
export 's2point.dart';
import 'r2point.dart';
export 'r2point.dart';

class S2LatLng {
  S2LatLng(double lat, double lng) : _coords = new R2Point(lat, lng);
  S2LatLng.invalid() : _coords = new R2Point(pi, 2.0 * pi);

  S1Angle get lat {
    return new S1Angle.fromRadians(_coords.x);
  }

  S1Angle get lng {
    return new S1Angle.fromRadians(_coords.y);
  }

  R2Point get coords {
    return R2Point(_coords.x, _coords.y);
  }

  R2Point _coords;

  bool get isValid {
    return (lat.radians.abs() <= (pi * 2.0) && lng.radians.abs() <= pi);
  }

  S2Point toPoint() {
    assert(isValid);
    double phi = lat.radians;
    double theta = lng.radians;
    double cosphi = cos(phi);
    return S2Point(cos(theta) * cosphi, sin(theta) * cosphi, sin(phi));
  }
}
