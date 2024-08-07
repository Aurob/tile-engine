#pragma once
#include "structs.hpp"

extern entt::registry registry;

Vector2f calculateOverlap(float AxT, float AxB, float BxT, float BxB, float AyT, float AyB, float ByT, float ByB)
{
    float xOverlapAmount = std::min(AxB - BxT, BxB - AxT);
    float yOverlapAmount = std::min(AyB - ByT, ByB - AyT);
    return Vector2f{xOverlapAmount, yOverlapAmount};
}

Vector2f calculateMoveDirection(float xOverlapAmount, float yOverlapAmount, float AxB, float BxT, float BxB, float AxT, float AyB, float ByT, float ByB, float AyT)
{
    Vector2f moveDirection{0.f, 0.f};
    if (xOverlapAmount < yOverlapAmount)
    {
        moveDirection.x = (AxB - BxT < BxB - AxT) ? -xOverlapAmount : xOverlapAmount;
    }
    else
    {
        moveDirection.y = (AyB - ByT < ByB - AyT) ? -yOverlapAmount : yOverlapAmount;
    }
    return moveDirection;
}

Vector2f positionsCollide(const Position &pos1, const Shape &shape1, 
                          const Position &pos2, const Shape &shape2, bool invert)
{
    Vector2f moveDirection{0.f, 0.f};
    float Ax = pos1.x, Ay = pos1.y;
    float Bx = pos2.x, By = pos2.y;

    float Aw = shape1.size.x, Ah = shape1.size.y;
    float Bw = shape2.size.x, Bh = shape2.size.y;

    float AxB = Ax + Aw, AxT = Ax, AyT = Ay, AyB = Ay + Ah;
    float BxB = Bx + Bw, BxT = Bx, ByT = By, ByB = By + Bh;

    if (invert) {
        // For inverted collisions (inside the interior)
        if (AxT <= BxT) moveDirection.x = BxT - AxT;
        else if (AxB >= BxB) moveDirection.x = BxB - AxB;

        if (AyT <= ByT) moveDirection.y = ByT - AyT;
        else if (AyB >= ByB) moveDirection.y = ByB - AyB;
    } else {
        // For regular collisions (outside the interior)
        bool xOverlap = (AxT < BxB && AxB > BxT);
        bool yOverlap = (AyT < ByB && AyB > ByT);

        if (xOverlap && yOverlap) {
            Vector2f overlap = calculateOverlap(AxT, AxB, BxT, BxB, AyT, AyB, ByT, ByB);
            moveDirection = calculateMoveDirection(overlap.x, overlap.y, AxB, BxT, BxB, AxT, AyB, ByT, ByB, AyT);
        }
    }

    return moveDirection;
}
