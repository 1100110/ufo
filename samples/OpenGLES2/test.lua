local ffi = require( "ffi" )
local egl = require( "ffi/EGL" )
local gl = require( "ffi/OpenGLES2" )

-- Use SDL for windowing and events
local function InitSDL()
   local sdl = require( "ffi/SDL" )
   local screen = sdl.SDL_SetVideoMode( 640, 480, 32, 0 )
   local wminfo = ffi.new( "SDL_SysWMinfo" )
   sdl.SDL_GetVersion( wminfo.version )
   sdl.SDL_GetWMInfo( wminfo )
   local systems = { "win", "x11", "dfb", "cocoa", "uikit" }
   local window = wminfo.info[systems[wminfo.subsystem]].window
   local event = ffi.new( "SDL_Event" )
   return {
      window = window,
      update = function() 
		  while sdl.SDL_PollEvent( event ) ~= 0 do
		     if event.type == sdl.SDL_QUIT then
			return false
		     end
		     if event.type == sdl.SDL_KEYUP and event.key.keysym.sym == sdl.SDLK_ESCAPE then
			event.type = sdl.SDL_QUIT
			sdl.SDL_PushEvent( event )
		     end
		  end
		  return true 
	       end,
      exit = function() 
		sdl.SDL_Quit() 
	     end,
   }
end

local wm = InitSDL()

local vs_src = [[
      attribute vec4        position;
      varying mediump vec2  pos;
      uniform vec4          offset;
      void main()
      {
	 gl_Position = position + offset;
	 pos = position.xy;
      }
]]

local fs_src = [[
      varying mediump vec2  pos;
      uniform mediump float phase;
      void  main()
      {
	 gl_FragColor = vec4( 1., 0.9, 0.7, 1.0 ) * cos( 30.*sqrt(pos.x*pos.x + 1.5*pos.y*pos.y)  + atan(pos.y,pos.x) - phase );
      }                                 
]]

--  some more formulas to play with...
--      cos( 20.*(pos.x*pos.x + pos.y*pos.y) - phase );
--      cos( 20.*sqrt(pos.x*pos.x + pos.y*pos.y) + atan(pos.y,pos.x) - phase );
--      cos( 30.*sqrt(pos.x*pos.x + 1.5*pos.y*pos.y - 1.8*pos.x*pos.y*pos.y)
--            + atan(pos.y,pos.x) - phase );

local dpy = egl.eglGetDisplay( egl.EGL_DEFAULT_DISPLAY )
local r = egl.eglInitialize( dpy, nil, nil )

local attr = ffi.new(
   "EGLint[3]", 
   egl.EGL_RENDERABLE_TYPE, egl.EGL_OPENGL_ES2_BIT,
   egl.EGL_NONE
)

local cfg = ffi.new( "EGLConfig[1]" )
local n_cfg = ffi.new( "EGLint[1]" )
local r = egl.eglChooseConfig( dpy, attr, cfg, 1, n_cfg )
local surf     = egl.eglCreateWindowSurface( dpy, cfg[0], wm.window, nil )
local ctx_attr = ffi.new( "EGLint[4]", egl.EGL_CONTEXT_CLIENT_VERSION, 2, egl.EGL_NONE, egl.EGL_NONE )
local ctx       = egl.eglCreateContext( dpy, cfg[0], nil, ctx_attr )
local r = egl.eglMakeCurrent( dpy, surf, surf, ctx )

local function print_shader_info( shader )
   local length = ffi.new( "GLint[1]" )
   gl.glGetShaderiv( shader, gl.GL_INFO_LOG_LENGTH, length )
   local length = length[0]
   if length <= 0 then
      return
   end
   local buffer = ffi.new( "char[?]", length )
   gl.glGetShaderInfoLog( shader, length, nil, buffer )
   print( ffi.string(buffer) )
   local success = ffi.new( "GLint[1]" )
   gl.glGetShaderiv( shader, gl.GL_COMPILE_STATUS, success )
   local success = success[0]
end
 
local function load_shader( src, type )
   local shader = gl.glCreateShader( type )
   local ptr = ffi.new( "char[?]", #src, src )
   local ptr2 = ffi.new( "const char*[1]", ptr )
   gl.glShaderSource( shader, 1, ptr2, nil )
   gl.glCompileShader ( shader );
   print_shader_info ( shader );
   return shader
end

local vs = load_shader( vs_src, gl.GL_VERTEX_SHADER )
local fs = load_shader( fs_src, gl.GL_FRAGMENT_SHADER )

local prog
local loc_position
local loc_phase   
local loc_offset  

if vs ~= nil and fs ~= nil then
   prog = gl.glCreateProgram()
   gl.glAttachShader( prog, vs )
   gl.glAttachShader( prog, fs )
   gl.glLinkProgram( prog )
   gl.glUseProgram( prog )
   
   loc_position = gl.glGetAttribLocation( prog, "position" )
   loc_phase    = gl.glGetUniformLocation( prog, "phase" )
   loc_offset   = gl.glGetUniformLocation( prog, "offset" )
end

local ww, wh = 640, 480

local phasep = 0
local update_pos = true 

local frames = 0
local phase = 0
local norm_x = 0
local norm_y = 0
local offset_x = 0
local offset_y = 0
local p1_pos_x = 0
local p1_pos_y = 0

local vertexArray = ffi.new(
   "float[15]",
   0.0,  0.5,  0.0,
   -0.5,  0.0,  0.0,
   0.0, -0.5,  0.0,
   0.5,  0.0,  0.0,
   0.0,  0.5,  0.0 
)

while wm:update() do
   frames = frames + 1

   gl.glViewport( 0, 0, ww, wh )
   gl.glClearColor( 0.08, 0.06, math.random()/4, 1)
   gl.glClear ( gl.GL_COLOR_BUFFER_BIT )
   gl.glUniform1f( loc_phase, phase )
   phase =  math.fmod( phase + 0.5, 2 * 3.141 )
 
   if update_pos  then
      local old_offset_x  =  offset_x;
      local old_offset_y  =  offset_y;
      
      offset_x  =  norm_x - p1_pos_x;
      offset_y  =  norm_y - p1_pos_y;
 
      p1_pos_x  =  norm_x;
      p1_pos_y  =  norm_y;
 
      offset_x  =  offset_x + old_offset_x;
      offset_y  =  offset_y + old_offset_y;
 
      update_pos = false;
   end
 
   gl.glUniform4f( loc_offset, offset_x , offset_y, 0.0 , 0.0 )
   gl.glVertexAttribPointer( loc_position, 3, gl.GL_FLOAT, gl.GL_FALSE, 0, vertexArray )
   gl.glEnableVertexAttribArray( loc_position )
   gl.glDrawArrays( gl.GL_TRIANGLE_STRIP, 0, 5 )
 
   egl.eglSwapBuffers( dpy, surf )
end

egl.eglDestroyContext( dpy, ctx )
egl.eglDestroySurface( dpy, surf )
egl.eglTerminate( dpy )
 
wm:exit()
