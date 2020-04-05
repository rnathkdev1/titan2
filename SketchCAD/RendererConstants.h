//
//  RendererConstants.h
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/4/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

#ifndef RendererConstants_h
#define RendererConstants_h


#ifdef __METAL_VERSION__
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#define NSInteger metal::int32_t
#else
#import <Foundation/Foundation.h>
#endif

#include <simd/simd.h>

// VertexBuffer parameters
typedef NS_ENUM(NSInteger, BufferIndex)
{
    BufferIndexPositions3D = 0,
    BufferIndexUniforms = 2,
    BufferIndexColors = 3,
};

// MetalVertexDescriptor parameters
typedef NS_ENUM(NSInteger, VertexAttribute)
{
    VertexAttributePosition3D  = 0,
    VertexAttributeIndex = 2,
    VertexAttributeIndex2D = 3,
};

// Camera parameters
typedef struct
{
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelViewMatrix;
} Transforms;

// Color constant parameters
typedef struct
{
    vector_float4 color;
} Colors;

#endif /* RendererConstants_h */
