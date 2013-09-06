--[[

A frame by frame bird animation example
The old frame is removed by Sprite:removeChild and the new frame is added by Sprite:addChild

This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2013 Gideros Mobile 

]]

local mystage = Sprite.new()

-- load texture, create bitmap from it and set as background
local background = Bitmap.new(Texture.new("sky_world.png"))
mystage:addChild(background)

-- these arrays contain the image file names of each frame
local frames1 = {
	"bird_black_01.png",
	"bird_black_02.png",
	"bird_black_03.png"}

local frames2 = {
	"bird_white_01.png",
	"bird_white_02.png",
	"bird_white_03.png"}

-- create 2 white and 2 black birds
local bird1 = Bird.new(frames1)
local bird2 = Bird.new(frames1)
local bird3 = Bird.new(frames2)
local bird4 = Bird.new(frames2)

-- add birds to the stage
mystage:addChild(bird1)
mystage:addChild(bird2)
mystage:addChild(bird3)
mystage:addChild(bird4)

local rt = RenderTarget.new(480, 320, true)

local mesh = Mesh.new()
mesh:setVertexArray(0, 0, 480, 0, 480, 320, 0, 320)
mesh:setTextureCoordinateArray(0, 0, 480, 0, 480, 320, 0, 320)
mesh:setIndexArray(1, 2, 3, 1, 3, 4)
mesh:setTexture(rt)
stage:addChild(mesh)

local effect = Effect.new("glsl",
[[
attribute vec4 POSITION0;
attribute vec2 TEXCOORD0;

uniform mat4 g_MVPMatrix;

varying vec2 texCoord;

void main()
{
	gl_Position = g_MVPMatrix * POSITION0;
	texCoord = TEXCOORD0;
}
]],
[[
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif

uniform lowp sampler2D g_Texture;
uniform lowp vec4 g_Color;
uniform highp float time;

varying highp vec2 texCoord;

void main()
{
	highp vec2 tc = texCoord.xy;
	highp float dist = cos(tc.x * 24.0 - time * 4.0) * 0.02;
	highp vec2 uv = tc + dist;
	gl_FragColor =  g_Color * texture2D(g_Texture, uv);
}
]])

mesh:setEffect(effect)

local start = os.timer()
local function onEnterFrame()
	effect:setParameter("time", os.timer() - start)
	rt:clear(0xffffff, 1.0)
	rt:draw(mystage)
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)
