{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverlappingInstances  #-}
{-# LANGUAGE UnicodeSyntax         #-}

module Roger.Robot( axleRadius
                  , armLength
                  , armOffset
                  , ballRadius
                  , baseline
                  , baseRadius
                  , focalLength
                  , Robot(..)
                  , Eyeθ(..)
                  , Eyeθ'(..)
                  , Armθ(..)
                  , Armθ'(..)
                  , mapRoger
                  , setRoger's
                  , ExtForce(..)
                  , BasePosition(..)
                  , BaseVelocity(..)
                  , BaseSetpoint(..)
                  , ArmSetpoint(..)
                  , EyeSetpoint(..)
) where

import           Control.Applicative
import           Control.Monad.State
import           Data.Vec
import           Foreign.Storable
import           Roger.TypedLens
import           Roger.Types

axleRadius ∷ Double
axleRadius = 0.20

armLength ∷ ArmPair Double
armLength = ArmPair { shoulder = 0.5, elbow = 0.5 }

armOffset ∷ Pair Double
armOffset = Pair { left = -0.18, right = 0.18 }

ballRadius ∷ Double
ballRadius = 0.20

baseline ∷ Double
baseline = 0.08

baseRadius ∷ Double
baseRadius = 0.16

focalLength ∷ Double
focalLength = 64 -- pixels

--------------------------------------------------------------------------------

data Robot = Robot { eyeθ         ∷ Pair Double
                   , eyeθ'        ∷ Pair Double
                   , image        ∷ Pair Image
                   , armθ         ∷ Pair (ArmPair Double)
                   , armθ'        ∷ Pair (ArmPair Double)
                   , extForce     ∷ Pair Vec2D
                   , basePosition ∷ VectorAndAngle
                   , baseVelocity ∷ VectorAndAngle
                   , wheelθ'      ∷ Pair Double
                   , eyeTorque    ∷ Pair Double
                   , armTorque    ∷ Pair (ArmPair Double)
                   , wheelTorque  ∷ Pair Double
                   , baseSetpoint ∷ VectorAndAngle
                   , armSetpoint  ∷ Pair (ArmPair Double)
                   , eyeSetpoint  ∷ Pair Double
                   }

--------------------------------------------------------------------------------
-- TypedLens `Has` instances for Robot. Not all of the fields are included here;
-- just the most common ones.

newtype Eyeθ         = Eyeθ  { getEyeθ ∷ Pair Double }
newtype Eyeθ'        = Eyeθ' { getEyeθ' ∷ Pair Double }
newtype Armθ         = Armθ  { getArmθ ∷ Pair (ArmPair Double) }
newtype Armθ'        = Armθ' { getArmθ' ∷ Pair (ArmPair Double) }
newtype ExtForce     = ExtForce     { getExtForce ∷ Pair Vec2D }
newtype BasePosition = BasePosition { getBasePosition ∷ VectorAndAngle }
newtype BaseVelocity = BaseVelocity { getBaseVelocity ∷ VectorAndAngle }
newtype BaseSetpoint = BaseSetpoint { getBaseSetpoint ∷ VectorAndAngle }
newtype ArmSetpoint  = ArmSetpoint  { getArmSetpoint ∷ Pair (ArmPair Double) }
newtype EyeSetpoint  = EyeSetpoint  { getEyeSetpoint ∷ Pair Double }

instance Has Eyeθ Robot where
  getL = Eyeθ . eyeθ
  putL (Eyeθ θ) r = r { eyeθ = θ }

instance Has Eyeθ' Robot where
  getL = Eyeθ' . eyeθ'
  putL (Eyeθ' θ') r = r { eyeθ' = θ' }

instance Has Armθ Robot where
  getL = Armθ . armθ
  putL (Armθ θ) r = r { armθ = θ }

instance Has Armθ' Robot where
  getL = Armθ' . armθ'
  putL (Armθ' θ') r = r { armθ' = θ' }

instance Has ExtForce Robot where
  getL = ExtForce . extForce
  putL (ExtForce v) r = r { extForce = v }

instance Has BasePosition Robot where
  getL = BasePosition . basePosition
  putL (BasePosition v) r = r { basePosition = v }

instance Has BaseVelocity Robot where
  getL = BaseVelocity . baseVelocity
  putL (BaseVelocity v) r = r { baseVelocity = v }

instance Has BaseSetpoint Robot where
  getL = BaseSetpoint . baseSetpoint
  putL (BaseSetpoint v) r = r { baseSetpoint = v }

instance Has ArmSetpoint Robot where
  getL = ArmSetpoint . armSetpoint
  putL (ArmSetpoint v) r = r { armSetpoint = v }

instance Has EyeSetpoint Robot where
  getL = EyeSetpoint . eyeSetpoint
  putL (EyeSetpoint v) r = r { eyeSetpoint = v }

mapRoger ∷ (Has Robot s, MonadState s m) ⇒ (Robot → Robot) → m ()
mapRoger = mapStateL

setRoger's a b = mapRoger (setL a b)

--------------------------------------------------------------------------------
-- Storable instance that allows us to read/write the C Robot struct.

instance Storable Robot where
  sizeOf _ = 494960 -- Obtained via C2HS. DO NOT EDIT.
  alignment _ = 4
  peek p = Robot <$> peekByteOff p offset'eye_theta
                 <*> peekByteOff p offset'eye_theta_dot
                 <*> peekByteOff p offset'image
                 <*> peekByteOff p offset'arm_theta
                 <*> peekByteOff p offset'arm_theta_dot
                 <*> peekByteOff p offset'ext_force
                 <*> peekByteOff p offset'base_position
                 <*> peekByteOff p offset'base_velocity
                 <*> peekByteOff p offset'wheel_theta_dot
                 <*> peekByteOff p offset'eye_torque
                 <*> peekByteOff p offset'arm_torque
                 <*> peekByteOff p offset'wheel_torque
                 <*> peekByteOff p offset'base_setpoint
                 <*> peekByteOff p offset'arm_setpoint
                 <*> peekByteOff p offset'eyes_setpoint
  poke p robot = do pokeByteOff p offset'eye_torque    (eyeTorque robot)
                    pokeByteOff p offset'arm_torque    (armTorque robot)
                    pokeByteOff p offset'wheel_torque  (wheelTorque robot)
                    pokeByteOff p offset'base_setpoint (baseSetpoint robot)
                    pokeByteOff p offset'arm_setpoint  (armSetpoint robot)
                    pokeByteOff p offset'eyes_setpoint (eyeSetpoint robot)

-- Offsets obtained via C2HS. DO NOT EDIT.
offset'eye_theta       = 0
offset'eye_theta_dot   = 16
offset'image           = 32
offset'arm_theta       = 3104
offset'arm_theta_dot   = 3136
offset'ext_force       = 3168
offset'base_position   = 3200
offset'base_velocity   = 3224
offset'wheel_theta_dot = 3248
offset'eye_torque      = 3264
offset'arm_torque      = 3280
offset'wheel_torque    = 3312
offset'base_setpoint   = 494888
offset'arm_setpoint    = 494912
offset'eyes_setpoint   = 494944

