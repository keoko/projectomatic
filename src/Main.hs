{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TemplateHaskell #-}

module Main where

import qualified Control.Lens as L
import Control.Applicative
import Snap (get)
import Snap.Snaplet
import Snap.Snaplet.PostgresqlSimple
import Database.PostgreSQL.Simple.FromRow
import Snap.Core
import Snap.Util.FileServe
import Snap.Http.Server
import qualified Data.Text as T
import Data.ByteString (ByteString)
import Data.Aeson 
import Control.Monad.IO.Class (liftIO)


data App = App
           { _pg :: Snaplet Postgres }

L.makeLenses ''App

instance HasPostgres (Handler b App) where
  getPostgresState = with pg get


data Project = Project
               { title :: T.Text
               , description :: T.Text
               }

instance FromRow Project where
  fromRow = Project <$> field <*> field

instance Show Project where
  show (Project title description) =
    "Project { title: " ++ T.unpack title ++ ", description: " ++ T.unpack description ++ "}n"

instance ToJSON Project where
  toJSON (Project title description) = object ["title" .= title
                                              , "description" .= description
                                              ]

jsonResponse :: MonadSnap m => m ()
jsonResponse = modifyResponse $ setHeader "Content-Type" "application/json"

writeJSON :: (MonadSnap m, ToJSON a) => a -> m ()
writeJSON a = do
  jsonResponse
  writeLBS . encode $ a

initApp :: SnapletInit App App
initApp = makeSnaplet "app" "My application." Nothing $ do
  pg <- nestSnaplet "pg" pg pgsInit
  addRoutes routes
  return $ App pg

routes :: [(ByteString, Handler App App ())]
routes = [ ("/project/new", method POST createNewProject)
         , ("/projects", method GET getAllProjects)
         , ("/project", method DELETE deleteProjectByTitle)
         ]

createNewProject :: Handler App App ()
createNewProject = do
  title <- getPostParam "title"
  description <- getPostParam "description"
  newProject <- execute "INSERT INTO projects VALUES (?, ?)" (title, description)
  redirect "/"

getAllProjects :: Handler App App ()
getAllProjects = do
  allProjects <- query_ "SELECT * FROM projects"
  liftIO $ print (allProjects :: [Project])
  writeJSON allProjects

deleteProjectByTitle :: Handler App App ()
deleteProjectByTitle = do
  title <- getPostParam "title"
  deleteProject <- execute "DELETE FROM projects WHERE title = ?" (Only title)
  redirect "/"


main :: IO ()
main = serveSnaplet defaultConfig initApp
