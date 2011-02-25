//
//  MyContactListener.mm
//  Ballgame
//
//  Created by Nathan Demick on 10/6/10.
//  Copyright 2010 Ganbaru Games. All rights reserved.
//

#import "MyContactListener.h"
#import "cocos2d.h"

MyContactListener::MyContactListener()
{
}

MyContactListener::~MyContactListener()
{
}

void MyContactListener::BeginContact(b2Contact *contact)
{
	ContactPoint c = { contact->GetFixtureA(), contact->GetFixtureB(), 0 };
	contactQueue.push_back(c);
	
}

void MyContactListener::EndContact(b2Contact *contact)
{
}

void MyContactListener::PreSolve(b2Contact *contact, const b2Manifold *oldManifold)
{
}

void MyContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse *impulse)
{
	// Create a contact point struct with fixtures & impulse
	ContactPoint c = { contact->GetFixtureA(), contact->GetFixtureB(), impulse->normalImpulses[0] };
	sfxQueue.push_back(c);
}
