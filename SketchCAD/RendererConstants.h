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
    
    // This can be the same buffer index
    // since they are different vertex descriptors.
    BufferIndexPositionsLine = 0,
    BufferIndexPositionsScreenspaceLine = 0,

    BufferIndexUniforms = 1,
    BufferIndexColors = 2,
};

// MetalVertexDescriptor parameters
typedef NS_ENUM(NSInteger, VertexAttribute)
{
    VertexAttributePosition3D  = 0,
    VertexAttributeColorIndex = 1,
    VertexAttributeIndex2D = 2,

    // These are part of the LineShader vertex
    // descriptor, so they can have same indices
    VertexAttributeThisVertex = 1,
    VertexAttributeNextVertex = 2,
    VertexAttributePrevVertex = 3,
    VertexAttributeDirection = 4,
    VertexAttributeLineColorIndex = 5,
};

// Camera parameters
typedef struct
{
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelViewMatrix;
    matrix_float4x4 screenspaceProjectionMatrix;
    float aspectRatio;
} Transforms;

// Color constant parameters
typedef struct
{
    vector_float4 color;
} Colors;

#endif /* RendererConstants_h */
