#pragma once

#include <SDL_opengles2.h>
#include <vector>
#include <unordered_map>
#include <string>

// map of shaders
std::unordered_map<std::string, vector<const GLchar*>> shaderGLSLMap;
std::unordered_map<std::string, GLuint> shaderProgramMap;
std::unordered_map<std::string, std::string> textureMap;
std::unordered_map<std::string, GLuint> textureIDMap;
