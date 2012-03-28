{-# LANGUAGE ScopedTypeVariables #-}
module Scheduler where

import Data.Maybe
import SoOSiM

import Scheduler.Types

scheduler schedState (ComponentMsg sender content) = do
  case (fromDynamic content) of
    (Just (cname :: String)) -> do
        compId <- createComponent Nothing cname
        sendMessageAsync Nothing sender (toDyn compId)
        return schedState
    Nothing -> return schedState

scheduler schedState _ = return schedState

createComponentRequest ::
  String
  -> SimM ComponentId
createComponentRequest s = do
  schedulerId    <- fmap fromJust $ componentLookup Nothing "Scheduler"
  componentIdDyn <- sendMessageSync Nothing schedulerId (toDyn s)
  return (fromJust $ fromDynamic componentIdDyn)

instance ComponentIface SchedulerState where
  initState          = SchedulerState
  componentName _    = "Scheduler"
  componentBehaviour = scheduler