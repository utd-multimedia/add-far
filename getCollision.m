function[collide] = getCollision(OBB1, OBB2)

RPos = OBB2.pos - OBB1.pos;
a1 = getSeparatingPlane(RPos, OBB1.u, OBB1, OBB2);
a2 = getSeparatingPlane(RPos, OBB1.v, OBB1, OBB2);
a3 = getSeparatingPlane(RPos, OBB1.w, OBB1, OBB2);
a4 = getSeparatingPlane(RPos, OBB2.u, OBB1, OBB2);
a5 = getSeparatingPlane(RPos, OBB2.v, OBB1, OBB2);
a6 = getSeparatingPlane(RPos, OBB2.w, OBB1, OBB2);
a7 = getSeparatingPlane(RPos, cross(OBB1.u, OBB2.u), OBB1, OBB2);
a8 = getSeparatingPlane(RPos, cross(OBB1.u, OBB2.v), OBB1, OBB2);
a9 = getSeparatingPlane(RPos, cross(OBB1.u, OBB2.w), OBB1, OBB2);
a10 = getSeparatingPlane(RPos, cross(OBB1.v, OBB2.u), OBB1, OBB2);
a11 = getSeparatingPlane(RPos, cross(OBB1.v, OBB2.v), OBB1, OBB2);
a12 = getSeparatingPlane(RPos, cross(OBB1.v, OBB2.w), OBB1, OBB2);
a13 = getSeparatingPlane(RPos, cross(OBB1.w, OBB2.u), OBB1, OBB2);
a14 = getSeparatingPlane(RPos, cross(OBB1.w, OBB2.v), OBB1, OBB2);
a15 = getSeparatingPlane(RPos, cross(OBB1.w, OBB2.w), OBB1, OBB2);
collide = ~(a1 | a2 | a3 | a4 | a5 | a6 | a7 | a8 | a9 | a10 | a11 | a12 | a13 | a14 | a15);

end

function[interS] = getSeparatingPlane(RPos, Plane, OBB1, OBB2)
a1 = abs(Plane' * (OBB1.halfU * OBB1.u));
a2 = abs(Plane' * (OBB1.halfV * OBB1.v));
a3 = abs(Plane' * (OBB1.halfW * OBB1.w));
a4 = abs(Plane' * (OBB2.halfU * OBB2.u));
a5 = abs(Plane' * (OBB2.halfV * OBB2.v));
a6 = abs(Plane' * (OBB2.halfW * OBB2.w));
interS = abs(Plane' * RPos) > (a1+a2+a3+a4+a5+a6);
end