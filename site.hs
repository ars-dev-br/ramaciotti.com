{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.Map as M
import Data.Maybe (fromMaybe)
import Data.Monoid ((<>), mconcat)
import Prelude hiding (id)

import Hakyll

data Blog = Blog {
    blogPosts :: Pattern
  , blogIndex :: Pattern
  , blogTags :: Pattern
  , blogSnapshot :: String
  , blogDefault :: Identifier
  , blogTagTitle :: String
  , blogPostsFile :: Identifier
  , blogPostList :: Identifier
  , blogPostBody :: Identifier
  , blogPostsTitle :: String
  , blogPages :: Pattern
  , blogRss :: Identifier
  , blogAtom :: Identifier
  , blogFeedConfig :: FeedConfiguration
}

buildBlog :: Blog -> Rules ()
buildBlog blog = do
  tags <- buildTags (blogPosts blog) (fromCapture (blogTags blog))

  match (blogPosts blog) $ do
    route $ setExtension ".html"
    compile $ do
      pandocCompiler
        >>= saveSnapshot (blogSnapshot blog)
        >>= loadAndApplyTemplate (blogPostBody blog) (postCtx tags)
        >>= loadAndApplyTemplate (blogDefault blog) defaultContext
        >>= relativizeUrls

  tagsRules tags $ \tag pattern -> do
    let title = (blogTagTitle blog) ++ tag
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll pattern
      let ctx = constField "title" title <>
                listField "posts" (postCtx tags) (return posts) <>
                defaultContext
      makeItem ""
        >>= loadAndApplyTemplate (blogPostList blog) ctx
        >>= loadAndApplyTemplate (blogDefault blog) ctx
        >>= relativizeUrls

  create [blogPostsFile blog] $ do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll (blogPosts blog)
      let ctx = constField "title" (blogPostsTitle blog) <>
                listField "posts" (postCtx tags) (return posts) <>
                defaultContext
      makeItem ""
        >>= loadAndApplyTemplate (blogPostList blog) ctx
        >>= loadAndApplyTemplate (blogDefault blog) ctx
        >>= relativizeUrls

  match (blogIndex blog) $ do
    route idRoute
    compile $ do
      posts <- fmap (take 5) . recentFirst =<< loadAll (blogPosts blog)
      let indexContext =
            listField "posts" (postCtx tags) (return posts) <>
            field "tags" (\_ -> renderTagList tags) <>
            defaultContext
      getResourceBody
        >>= applyAsTemplate indexContext
        >>= loadAndApplyTemplate (blogDefault blog) indexContext
        >>= relativizeUrls

  match (blogPages blog) $ do
    route $ setExtension ".html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate (blogDefault blog) defaultContext
      >>= relativizeUrls

  create [blogRss blog] $ do
    route $ idRoute
    compile $ do
      loadAllSnapshots (blogPosts blog) (blogSnapshot blog)
        >>= fmap (take 10) . recentFirst
        >>= renderRss (blogFeedConfig blog) feedCtx

  create [blogAtom blog] $ do
    route $ idRoute
    compile $ do
      loadAllSnapshots (blogPosts blog) (blogSnapshot blog)
        >>= fmap (take 10) . recentFirst
        >>= renderAtom (blogFeedConfig blog) feedCtx

main :: IO ()
main = hakyllWith config $ do
  match ("css/*.css" .||. "files/*" .||. "font/*" .||. "img/*" .||. "js/*") $ do
    route idRoute
    compile copyFileCompiler

  match ("templates/*" .||. "templates-en/*") $ do
    compile templateCompiler

  match "index.html" $ do
    route idRoute
    compile copyFileCompiler

  buildBlog $ Blog {
                blogPosts = "posts/*"
              , blogIndex = "index-pt.html"
              , blogTags = "tags/*.html"
              , blogSnapshot = "content"
              , blogDefault = "templates/default.html"
              , blogTagTitle = "Artigos com a tag "
              , blogPostsFile = "posts.html"
              , blogPostList = "templates/post-list.html"
              , blogPostBody = "templates/post-body.html"
              , blogPostsTitle = "Todos os Artigos"
              , blogPages = ("sobre.md" .||. "recomendacoes.md")
              , blogRss = "ramaciotti.rss"
              , blogAtom = "ramaciotti.atom"
              , blogFeedConfig = feedConfiguration
              }

  buildBlog $ Blog {
                blogPosts = "posts-en/*"
              , blogIndex = "index-en.html"
              , blogTags = "tags-en/*.html"
              , blogSnapshot = "content-en"
              , blogDefault = "templates-en/default.html"
              , blogTagTitle = "Articles on "
              , blogPostsFile = "posts-en.html"
              , blogPostList = "templates-en/post-list.html"
              , blogPostBody = "templates-en/post-body.html"
              , blogPostsTitle = "All Articles"
              , blogPages = ("about.md" .||. "recomendations.md")
              , blogRss = "ramaciotti-en.rss"
              , blogAtom = "ramaciotti-en.atom"
              , blogFeedConfig = feedConfiguration
              }

feedCtx :: Context String
feedCtx = mconcat
    [ bodyField "description"
    , defaultContext
    ]

postCtx :: Tags -> Context String
postCtx tags = mconcat
               [ modificationTimeField "modified" "%Y-%m-%d"
               , dateField "timestamp" "%Y-%m-%d"
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

feedConfigurationEn = FeedConfiguration {
                        feedTitle = "ramaciotti.com"
                      , feedDescription = "Texts on software development."
                      , feedAuthorName = "André Ramaciotti"
                      , feedAuthorEmail = "andre@ramaciotti.com"
                      , feedRoot = "http://ramaciotti.com/"
                      }
