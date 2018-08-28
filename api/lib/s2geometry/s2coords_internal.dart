// The canonical Hilbert traversal order looks like an inverted 'U':
// the subcells are visited in the order (0,0), (0,1), (1,1), (1,0).
// The following tables encode the traversal order for various
// orientations of the Hilbert curve (axes swapped and/or directions
// of the axes reversed).

// Together these flags define a cell orientation.  If 'kSwapMask'
// is true, then canonical traversal order is flipped around the
// diagonal (i.e. i and j are swapped with each other).  If
// 'kInvertMask' is true, then the traversal order is rotated by 180
// degrees (i.e. the bits of i and j are inverted, or equivalently,
// the axis directions are reversed).
const int kSwapMask = 0x01;
const int kInvertMask = 0x02;

// kIJtoPos[orientation][ij] -> pos
//
// Given a cell orientation and the (i,j)-index of a subcell (0=(0,0),
// 1=(0,1), 2=(1,0), 3=(1,1)), return the order in which this subcell is
// visited by the Hilbert curve (a position in the range [0..3]).
const List<List<int>> kIJtoPos = [
  // (0,0) (0,1) (1,0) (1,1)
  [0, 1, 3, 2], // canonical order
  [0, 3, 1, 2], // axes swapped
  [2, 3, 1, 0], // bits inverted
  [2, 1, 3, 0], // swapped & inverted
];

// kPosToIJ[orientation][pos] -> ij
//
// Return the (i,j) index of the subcell at the given position 'pos' in the
// Hilbert curve traversal order with the given orientation.  This is the
// inverse of the previous table:
//
//   kPosToIJ[r][kIJtoPos[r][ij]] == ij
const List<List<int>> kPosToIJ = [
  // 0  1  2  3
  [0, 1, 3, 2], // canonical order:    (0,0), (0,1), (1,1), (1,0)
  [0, 2, 3, 1], // axes swapped:       (0,0), (1,0), (1,1), (0,1)
  [3, 2, 0, 1], // bits inverted:      (1,1), (1,0), (0,0), (0,1)
  [3, 1, 0, 2], // swapped & inverted: (1,1), (0,1), (0,0), (1,0)
];

// kPosToOrientation[pos] -> orientation_modifier
//
// Return a modifier indicating how the orientation of the child subcell
// with the given traversal position [0..3] is related to the orientation
// of the parent cell.  The modifier should be XOR-ed with the parent
// orientation to obtain the curve orientation in the child.
const List<int> kPosToOrientation = [
  kSwapMask,
  0,
  0,
  kInvertMask + kSwapMask,
];

// The U,V,W axes for each face.
const List<List<List<double>>> kFaceUVWAxes = [
  [
    [4.0, 1.0],
    [5.0, 2.0],
    [3.0, 0.0]
  ],
  [
    [0.0, 3.0],
    [5.0, 2.0],
    [4.0, 1.0]
  ],
  [
    [0.0, 3.0],
    [1.0, 4.0],
    [5.0, 2.0]
  ],
  [
    [2.0, 5.0],
    [1.0, 4.0],
    [0.0, 3.0]
  ],
  [
    [2.0, 5.0],
    [3.0, 0.0],
    [1.0, 4.0]
  ],
  [
    [4.0, 1.0],
    [3.0, 0.0],
    [2.0, 5.0]
  ]
];

// The precomputed neighbors of each face (see GetUVWFace).
const List<List<List<int>>> kFaceUVWFaces = [
  [
    [0, 1, 0],
    [0, 0, 1],
    [1, 0, 0]
  ],
  [
    [-1, 0, 0],
    [0, 0, 1],
    [0, 1, 0]
  ],
  [
    [-1, 0, 0],
    [0, -1, 0],
    [0, 0, 1]
  ],
  [
    [0, 0, -1],
    [0, -1, 0],
    [-1, 0, 0]
  ],
  [
    [0, 0, -1],
    [1, 0, 0],
    [0, -1, 0]
  ],
  [
    [0, 1, 0],
    [1, 0, 0],
    [0, 0, -1]
  ]
];
