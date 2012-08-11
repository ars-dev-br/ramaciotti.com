{-# LANGUAGE OverloadedStrings, Arrows #-}

module Main where

import Prelude hiding (id)
import Control.Category (id)
import Control.Monad (forM_)
import Control.Arrow (arr, (>>>), (***), second)
import Data.Monoid (mempty, mconcat)
import qualified Data.Map as M

import Hakyll
import Hakyll.Web.Feed

main :: IO ()
main = hakyllWith config $ do
        -- copy css (it's alredy minified by less)
        match "css/*.min.css" $ do
          route idRoute
          compile copyFileCompiler

        -- copy files
        match "files/*" $ do
          route idRoute
          compile copyFileCompiler

        -- copy fonts
        match "font/*" $ do
          route idRoute
          compile copyFileCompiler

        -- copy images
        match "img/*" $ do
          route idRoute
          compile copyFileCompiler

        -- copy scripts
        match "js/*" $ do
          route idRoute
          compile copyFileCompiler

        -- compile templates
        match "templates/*" $ do
          compile templateCompiler

        -- compile posts
        match "posts/*" $ do
          route $ setExtension ".html"
          compile $ pageCompiler
            >>> arr (renderDateField "timestamp" "%Y-%m-%d" "Data desconhecida")
            >>> renderTagsField "posttags" (fromCapture "tags/*")
            >>> applyTemplateCompiler "templates/post-body.html"
            >>> applyTemplateCompiler "templates/default.html"
            >>> relativizeUrlsCompiler

        -- compile tags
        create "tags" $ requireAll "posts/*" (\_ ps -> readTags ps :: Tags String)
        match "tags/*" $ route $ setExtension ".html"
        metaCompile $ require_ "tags"
          >>> arr tagsMap
          >>> arr (map (\(t, p) -> (tagIdentifier t, makeTagList t p)))

        -- compile posts
        match "posts.html" $ route idRoute
        create "posts.html" $ constA mempty
          >>> arr (setField "title" "Todos os Artigos")
          >>> setFieldPageList recentFirst "templates/post-list-item.html" "posts" "posts/*"
          >>> applyTemplateCompiler "templates/post-list.html"
          >>> applyTemplateCompiler "templates/default.html"
          >>> relativizeUrlsCompiler

        -- compile index
        match "index.html" $ route idRoute
        create "index.html" $ constA mempty
          >>> arr (setField "title" "Inicial")
          >>> requireA "tags" (setFieldA "tags" (renderTagList'))
          >>> setFieldPageList (take 5 . recentFirst) "templates/post-list-item.html" "posts" "posts/*"
          >>> applyTemplateCompiler "templates/index.html"
          >>> applyTemplateCompiler "templates/default.html"
          >>> relativizeUrlsCompiler

        -- compile sobre
        match "sobre.md" $ do
          route $ setExtension ".html"
          compile $ pageCompiler
            >>> applyTemplateCompiler "templates/default.html"
            >>> relativizeUrlsCompiler

        -- compile rss
        match "ramaciotti.rss" $ route idRoute
        create "ramaciotti.rss" $ requireAll_ "posts/*"
          >>> mapCompiler (arr $ copyBodyToField "description")
          >>> renderRss feedConfiguration

        return ()
    where
      renderTagList' :: Compiler (Tags String) String
      renderTagList' = renderTagList tagIdentifier

      tagIdentifier :: String -> Identifier (Page String)
      tagIdentifier = fromCapture "tags/*"

config = defaultHakyllConfiguration {
           deployCommand = "rsync --checksum -e ssh -av _site/ \
             \ramaciotti@pulcherrima.dreamhost.com:ramaciotti.com"
         }

feedConfiguration = FeedConfiguration {
                      feedTitle = "ramaciotti.com"
                    , feedDescription = "Textos sobre desenvolvimento de software."
                    , feedAuthorName = "André Ramaciotti"
                    , feedRoot = "http://ramaciotti.com/"
                    }

makeTagList :: String -> [Page String] -> Compiler () (Page String)
makeTagList tag posts = constA posts
                          >>> pageListCompiler recentFirst "templates/post-list-item.html"
                          >>> arr (copyBodyToField "posts" . fromBody)
                          >>> arr (setField "title" ("Artigos sobre " ++ tag))
                          >>> applyTemplateCompiler "templates/post-list.html"
                          >>> applyTemplateCompiler "templates/default.html"
                          >>> relativizeUrlsCompiler

