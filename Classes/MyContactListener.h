//
//  MyContactListener.h
//  Ballgame
//
//  Created by Nathan Demick on 10/6/10.
//  Copyright 2010 Ganbaru Games. All rights reserved.
//

#import "Box2D.h"
#import "cocos2d.h"
#import <vector>
#import <algorithm>

struct ContactPoint {
    b2Fixture *fixtureA;
    b2Fixture *fixtureB;
	float impulse;
	
    bool operator == (const ContactPoint& other) const
    {
        return (fixtureA == other.fixtureA) && (fixtureB == other.fixtureB);
    }
};

class MyContactListener : public b2ContactListener 
{
public:
	
	// Vectors that store contact points from BeginContact (contactQueue) and PostSolve (sfxQueue)
	std::vector<ContactPoint>contactQueue;
	std::vector<ContactPoint>sfxQueue;
	
	MyContactListener();
	~MyContactListener();
	
	virtual void BeginContact(b2Contact *contact);
	virtual void EndContact(b2Contact *contact);
	virtual void PreSolve(b2Contact *contact, const b2Manifold *oldManifold);
	virtual void PostSolve(b2Contact *contact, const b2ContactImpulse *impulse);
};

