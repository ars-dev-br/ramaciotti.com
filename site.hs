{-# LANGUAGE Arrows #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Monoid ((<>), mconcat)
import Prelude hiding (id)

import Hakyll

main :: IO ()
main = hakyllWith config $ do
  match ("css/*.css" .||. "files/*" .||. "font/*" .||. "img/*" .||. "js/*") $ do
    route idRoute
    compile copyFileCompiler

  match "templates/*" $ do
    compile templateCompiler

  tags <- buildTags "posts/*" (fromCapture "tags/*.html")

  match "posts/*" $ do
    route $ setExtension ".html"
    compile $ do
      pandocCompiler
        >>= saveSnapshot "content"
        >>= loadAndApplyTemplate "templates/post-body.html" (postCtx tags)
        >>= loadAndApplyTemplate "templates/default.html" defaultContext
        >>= relativizeUrls

  tagsRules tags $ \tag pattern -> do
    let title = "Artigos com a tag " ++ tag
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll pattern
      let ctx = constField "title" title <>
                listField "posts" (postCtx tags) (return posts) <>
                defaultContext
      makeItem ""
        >>= loadAndApplyTemplate "templates/post-list.html" ctx
        >>= loadAndApplyTemplate "templates/default.html" ctx
        >>= relativizeUrls

  create ["posts.html"] $ do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll "posts/*"
      let ctx = constField "title" "Todos os Artigos" <>
                listField "posts" (postCtx tags) (return posts) <>
                defaultContext
      makeItem ""
        >>= loadAndApplyTemplate "templates/post-list.html" ctx
        >>= loadAndApplyTemplate "templates/default.html" ctx
        >>= relativizeUrls

  match "index.html" $ do
    route idRoute
    compile $ do
      posts <- fmap (take 5) . recentFirst =<< loadAll "posts/*"
      let indexContext =
            listField "posts" (postCtx tags) (return posts) <>
            field "tags" (\_ -> renderTagList tags) <>
            defaultContext

      getResourceBody
        >>= applyAsTemplate indexContext
        >>= loadAndApplyTemplate "templates/default.html" indexContext
        >>= relativizeUrls

  match ("sobre.md" .||. "recomendacoes.md") $ do
    route $ setExtension ".html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  create ["ramaciotti.rss"] $ do
    route $ idRoute
    compile $ do
      loadAllSnapshots "posts/*" "content"
        >>= fmap (take 10) . recentFirst
        >>= renderRss feedConfiguration feedCtx

feedCtx :: Context String
feedCtx = mconcat
    [ bodyField "description"
    , defaultContext
    ]

postCtx :: Tags -> Context String
postCtx tags = mconcat
               [ modificationTimeField "modified" "%d/%m/%Y"
               , dateField "timestamp" "%d/%m/%Y"
               , tagsField "posttags" tags
               , defaultContext
               ]

config = defaultConfiguration {
  deployCommand = "rsync --checksum -e \"ssh -p 30000\" -av _site/ \
             \serenity.ramaciotti.com:/srv/www/www.ramaciotti.com/public"
}

feedConfiguration = FeedConfiguration {
                      feedTitle = "ramaciotti.com"
                    , feedDescription = "Textos sobre desenvolvimento de software."
                    , feedAuthorName = "André Ramaciotti"
                    , feedAuthorEmail = "andre@ramaciotti.com"
                    , feedRoot = "http://ramaciotti.com/"
                    }
