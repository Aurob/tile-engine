#pragma once

#include <vector>

using namespace std;

struct context
{
    SDL_Event event;
    int iteration;
    SDL_Window *window;
};

struct Vector2 {
    int x, y;
};

struct Vector2f {
    float x, y;
};

struct Vector3f {
    float x, y, z;
};

// Entity Components


struct Player {};
struct Position {
    float x;
    float y;
    float sx;
    float sy;
};

struct Shape {
    Vector3f size{10, 10, 10};
    Vector3f scaled_size;
};

struct Color {
    float r;
    float g;
    float b;
    float a;
};

struct Validation {
    int state{0};
};

struct Visible {};

struct Debug {
    Color defaultColor;
};

struct Teleport {
    Position origin;
    Position destination;
    bool reverse{false};
};

struct Hoverable {};
struct Hovered {};

struct Interactable {};
struct Interacted {};

struct Collisions {};
struct Colliding{
    std::vector<entt::entity> colliding_entities;
};
struct Collidable {
    std::vector<entt::entity> colliding_with;
};

struct Movement {
    float speed{10};
    float max_speed{110};
    Vector2f velocity{0, 0};
    Vector2f acceleration{0, 0};
    float friction{1};
    float mass{1};
};
struct Moveable {};

