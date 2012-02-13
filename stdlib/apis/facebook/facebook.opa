/*
    Copyright © 2011 MLstate

    This file is part of OPA.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
/*
 * Author    : Nicolas Glondu <nicolas.glondu@mlstate.com>
 **/

/**
 * Facebook generic API module
 *
 * @category api
 * @author Nicolas Glondu, 2011
 * @destination public
 */

import stdlib.apis.common

/**
 * {1 About this module}
 *
 * This module provides some generic elements common to all facebook submodules
 * Important :
 *   Any application using this must respect
 *   {{:http://developers.facebook.com/policy}Facebook policy}
 *
 * {1 Where should I start?}
 *
 * You should first {{:https://www.facebook.com/developers/}register an app}
 * to get a application id, an api key and an application secret. You will
 * also have to configure various parameters on your application. Once done,
 * look the module [FbAuth] to obtain an access token from users. You can
 * now use any Facebook API.
 */

/**
 * Configuration for Facebook Graph API
 * All these are obtained after creating an application using Facebook
 * Developper app: https://www.facebook.com/developers/
 */
type Facebook.config = {
  app_id     : string
  api_key    : string
  app_secret : string
}

/**
 * A Facebook error
 * - [error] Short message identifying the error. Errors starting with "opa_" are
     generated by this module while others are sent back by Facebook.
 * - [error_description] Longer description of the error (in English). Errors
     generated by this module start with [OPA]. You should not show these errors
     end errors.
 */
type Facebook.error = {
  error             : string
  error_description : string
}

/**
 * Permissions that can be requested to active user
 * A list of all permissions with what they stand for can be obtained at:
 * https://developers.facebook.com/docs/authentication/permissions/
 */
type Facebook.permission =
  /* Data permissions - self */
    { user_about_me }			/** Provides access to the "About Me" section of the profile in the about property */
  / { user_activities }			/** Provides access to the user's list of activities as the activities connection */
  / { user_birthday }			/** Provides access to the birthday with year as the birthday_date property */
  / { user_education_history }		/** Provides access to education history as the education property */
  / { user_events }			/** Provides access to the list of events the user is attending as the events connection */
  / { user_groups }			/** Provides access to the list of groups the user is a member of as the groups connection */
  / { user_hometown }			/** Provides access to the user's hometown in the hometown property */
  / { user_interests }			/** Provides access to the user's list of interests as the interests connection */
  / { user_likes }			/** Provides access to the list of all of the pages the user has liked as the likes connection */
  / { user_location }			/** Provides access to the user's current location as the location property */
  / { user_notes }			/** Provides access to the user's notes as the notes connection */
  / { user_online_presence }		/** Provides access to the user's online/offline presence */
  / { user_photo_video_tags }		/** Provides access to the photos the user has been tagged in as the photos connection */
  / { user_photos }			/** Provides access to the photos the user has uploaded */
  / { user_relationships }		/** Provides access to the user's family and personal relationships and rela
tionship status */
  / { user_relationship_details }	/** Provides access to the user's relationship preferences */
  / { user_religion_politics }		/** Provides access to the user's religious and political affiliations */
  / { user_status }			/** Provides access to the user's most recent status message */
  / { user_videos }			/** Provides access to the videos the user has uploaded */
  / { user_website }			/** Provides access to the user's web site URL */
  / { user_work_history }		/** Provides access to work history as the work property */
  / { email }				/** Provides access to the user's primary email address in the email property. Do not spam users. Your use of email must comply both with Facebook policies and with the CAN-SPAM Act. */
  / { read_friendlists }		/** Provides access to any friend lists the user created. All user's friends are provided as part of basic data, this extended permission grants access to the lists of friends a user has created, and should only be requested if your application utilizes lists of friends. */
  / { read_insights }			/** Provides read access to the Insights data for pages, applications, and domains the user owns. */
  / { read_mailbox }			/** Provides the ability to read from a user's Facebook Inbox. */
  / { read_requests }			/** Provides read access to the user's friend requests */
  / { read_stream }			/** Provides access to all the posts in the user's News Feed and enables your application to perform searches against the user's News Feed */
  / { xmpp_login }			/** Provides applications that integrate with Facebook Chat the ability to log in users. */
  / { ads_management }			/** Provides the ability to manage ads and call the Facebook Ads API on behalf of a user. */
  / { user_checkins }			/** Provides read access to the authorized user's check-ins or a friend's check-ins that the user can see. */
  /* Data permissions - friends */
  / { friends_about_me }		 /** Provides access to the "About Me" section of the profile in the about property */
  / { friends_activities }		/** Provides access to the user's list of activities as the activities connection */
  / { friends_birthday }		/** Provides access to the birthday with year as the birthday_date property */
  / { friends_education_history }	/** Provides access to education history as the education property */
  / { friends_events }			/** Provides access to the list of events the user is attending as the events connection */
  / { friends_groups }			/** Provides access to the list of groups the user is a member of as the groups connection */
  / { friends_hometown }		/** Provides access to the user's hometown in the hometown property */
  / { friends_interests }		/** Provides access to the user's list of interests as the interests connection */
  / { friends_likes }			/** Provides access to the list of all of the pages the user has liked as the likes connection */
  / { friends_location }		/** Provides access to the user's current location as the location property */
  / { friends_notes }			/** Provides access to the user's notes as the notes connection */
  / { friends_online_presence }		/** Provides access to the user's online/offline presence */
  / { friends_photo_video_tags }	/** Provides access to the photos the user has been tagged in as the photos connection */
  / { friends_photos }			/** Provides access to the photos the user has uploaded */
  / { friends_relationships }		/** Provides access to the user's family and personal relationships and relationship status */
  / { friends_relationship_details }	/** Provides access to the user's relationship preferences */
  / { friends_religion_politics }	/** Provides access to the user's religious and political affiliations */
  / { friends_status }			/** Provides access to the user's most recent status message */
  / { friends_videos }			/** Provides access to the videos the user has uploaded */
  / { friends_website }			/** Provides access to the user's web site URL */
  / { friends_work_history }		/** Provides access to work history as the work property */
  / { manage_friendlists }		/** Provides access to any friend lists the user created. All user's friends are provided as part of basic data, this extended permission grants access to the lists of friends a user has created, and should only be requested if your application utilizes lists of friends. */
  / { friends_checkins }		/** Provides read access to the authorized user's check-ins or a friend's check-ins that the user can see. */
  /* Publishing permissions */
  / { publish_stream } 			/** Enables your application to post content, comments, and likes to a user's stream and to the streams of the user's friends. With this permission, you can publish content to a user's feed at any time, without requiring offline_access. However, please note that Facebook recommends a user-initiated sharing model. */
  / { create_event } 			/** Enables your application to create and modify events on the user's behalf */
  / { rsvp_event } 			/**  Enables your application to RSVP to events on the user's behalf */
  / { sms } 				/** Enables your application to send messages to the user and respond to messages from the user via text message */
  / { offline_access }		 	/** Enables your application to perform authorized requests on behalf of the user at any time. By default, most access tokens expire after a short time period to ensure applications only make requests on behalf of the user when the are actively using the application. This permission makes the access token returned by our OAuth endpoint long-lived. */
  / { publish_checkins } 		/** Enables your application to perform checkins on behalf of the user */
  /* Page permissions */
  / { manage_pages } 			/** Enables your application to retrieve access_tokens for pages the user administrates. The access tokens can be queried using the "accounts" connection in the Graph API. This permission is only compatible with the Graph API. */

/**
 * Link in a feed
 * [text] short text describing the link
 * [href] uri of the link. Note that Facebook will not transform the link, which
 * means you can put either an absolute or a relative address.
 */
type Facebook.feed_link = {
  text : string /* also known as name */
  href : string /* also known as link */
}

/**
 * Property of a feed
 * See [Facebook.feed_options] for more information on feeds.
 */
type Facebook.feed_property =
    { simple : string }             /** A simple text property */
  / { link   : Facebook.feed_link } /** A property with a link */

/**
 * A Facebook feed for [FbDialog.full_feed] and [FbGraph.Post.feed].
 * Default value is [Facebook.empty_feed].
 * - [from] ID or username of the user posting the message. If this is
 *   unspecified, it defaults to the current user. If specified, it must be
 *   the ID of the user or of a page that the user administers. NOT usable
 *   in [FbGraph.Post.feed].
 * - [to] ID or username of the profile on which this feed will be published
 *   If this is unspecified, it defaults to the the value of [from]. NOT
 *   usable with [FbGraph.Post.feed].
 * - [message] Message of the feed. If used in a dialog, it will prefill the text
 *   field that the user will type in. In this case, to be compliant with
 *   Facebook Platform Policies, your application may only set this field if
 *   the user manually generated the content earlier in the workflow. Most
 *   applications should not set this.
 * - [link] Link attached to this post
 * - [picture] URL of a picture attached to this post.
 * - [source] URL of a media file (e.g., a SWF or video file) attached to
 *   this post. If both source and picture are specified, only source is used.
 * - [name] Name of the link attachment.
 * - [caption] Caption of the link (appears beneath the link name).
 * - [description] Description of the link (appears beneath the link caption).
 * - [properties] List of [FbDialog.feed_property] which will appear in
 *   the stream attachment beneath the description, with each property on its
 *   own line. Keys must be strings, and values can be either strings or JSON
 *   objects with the keys text and href. Will only appear if there is a link.
 * - [actions] List of [FbDialog.feed_link] which will appear next to
 *   the "Comment" and "Like" link under posts.
 */

type Facebook.feed = {
  from        : string
  to          : string
  message     : string
  link        : string
  picture     : string
  source      : string
  name        : string
  caption     : string
  description : string
  properties  : list(Facebook.feed_property)
  actions     : list(Facebook.feed_link)
}

Facebook = {{

  /* Facebook static */

  server_url = "https://www.facebook.com"

  /* Errors */

  make_error(error, descr) : Facebook.error = {
    error = error
    error_description = descr
  }

  /**
   * One of the errors generated by this module. Returned when incorrect
   * parameters are provided to a function.
   */
  data_error = make_error("opa_data_error", "[OPA]Error in data")

  /**
   * One of the errors generated by this module. Returned when 
   * trying to acces an object fails.
   */
  access_denied = make_error("opa_access_denied", "[OPA]Error: access denied")

  /**
   * One of the errors generated by this module. Returned after a communication
   * error with Facebook server. May happen if no internet access is available.
   */
  network_error = make_error("opa_network_error", "[OPA]Error during transmission")

  /**
   * Error during JSON parsing. Should not happen.
   */
  parse_error(res) = make_error("opa_parse_error", "[OPA]Error during treatments: \n {res} \n --- is not JSON ---")

  /* to_string functions */

  permission_to_string(p) =
    match p:Facebook.permission with
    { user_about_me }                -> "user_about_me"
    { user_activities }              -> "user_activities"
    { user_birthday }                -> "user_birthday"
    { user_education_history }       -> "user_education_history"
    { user_events }                  -> "user_events"
    { user_groups }                  -> "user_groups"
    { user_hometown }                -> "user_hometown"
    { user_interests }               -> "user_interests"
    { user_likes }                   -> "user_likes"
    { user_location }                -> "user_location"
    { user_notes }                   -> "user_notes"
    { user_online_presence }         -> "user_online_presence"
    { user_photo_video_tags }        -> "user_photo_video_tags"
    { user_photos }                  -> "user_photos"
    { user_relationships }           -> "user_relationships"
    { user_relationship_details }    -> "user_relationship_details"
    { user_religion_politics }       -> "user_religion_politics"
    { user_status }                  -> "user_status"
    { user_videos }                  -> "user_videos"
    { user_website }                 -> "user_website"
    { user_work_history }            -> "user_work_history"
    { email }                        -> "email"
    { read_friendlists }             -> "read_friendlists"
    { read_insights }                -> "read_insights"
    { read_mailbox }                 -> "read_mailbox"
    { read_requests }                -> "read_requests"
    { read_stream }                  -> "read_stream"
    { xmpp_login }                   -> "xmpp_login"
    { ads_management }               -> "ads_management"
    { user_checkins }                -> "user_checkins"
    { friends_about_me }             -> "friends_about_me"
    { friends_activities }           -> "friends_activities"
    { friends_birthday }             -> "friends_birthday"
    { friends_education_history }    -> "friends_education_history"
    { friends_events }               -> "friends_events"
    { friends_groups }               -> "friends_groups"
    { friends_hometown }             -> "friends_hometown"
    { friends_interests }            -> "friends_interests"
    { friends_likes }                -> "friends_likes"
    { friends_location }             -> "friends_location"
    { friends_notes }                -> "friends_notes"
    { friends_online_presence }      -> "friends_online_presence"
    { friends_photo_video_tags }     -> "friends_photo_video_tags"
    { friends_photos }               -> "friends_photos"
    { friends_relationships }        -> "friends_relationships"
    { friends_relationship_details } -> "friends_relationship_details"
    { friends_religion_politics }    -> "friends_religion_politics"
    { friends_status }               -> "friends_status"
    { friends_videos }               -> "friends_videos"
    { friends_website }              -> "friends_website"
    { friends_work_history }         -> "friends_work_history"
    { manage_friendlists }           -> "manage_friendlists"
    { friends_checkins }	     -> "friends_checkins"
    { publish_stream }               -> "publish_stream"
    { create_event }                 -> "create_event"
    { rsvp_event }                   -> "rsvp_event"
    { sms }                          -> "sms"
    { offline_access }               -> "offline_access"
    { publish_checkins }             -> "publish_checkins"
    { manage_pages }                 -> "manage_pages"

  permission_of_string(p) : option(Facebook.permission) =
    match p:string with
    "user_about_me"                -> {some={user_about_me}}
    "user_activities"              -> {some={user_activities}}
    "user_birthday"                -> {some={user_birthday}}
    "user_education_history"       -> {some={user_education_history}}
    "user_events"                  -> {some={user_events}}
    "user_groups"                  -> {some={user_groups}}
    "user_hometown"                -> {some={user_hometown}}
    "user_interests"               -> {some={user_interests}}
    "user_likes"                   -> {some={user_likes}}
    "user_location"                -> {some={user_location}}
    "user_notes"                   -> {some={user_notes}}
    "user_online_presence"         -> {some={user_online_presence}}
    "user_photo_video_tags"        -> {some={user_photo_video_tags}}
    "user_photos"                  -> {some={user_photos}}
    "user_relationships"           -> {some={user_relationships}}
    "user_relationship_details"    -> {some={user_relationship_details}}
    "user_religion_politics"       -> {some={user_religion_politics}}
    "user_status"                  -> {some={user_status}}
    "user_videos"                  -> {some={user_videos}}
    "user_website"                 -> {some={user_website}}
    "user_work_history"            -> {some={user_work_history}}
    "email"                        -> {some={email}}
    "read_friendlists"             -> {some={read_friendlists}}
    "read_insights"                -> {some={read_insights}}
    "read_mailbox"                 -> {some={read_mailbox}}
    "read_requests"                -> {some={read_requests}}
    "read_stream"                  -> {some={read_stream}}
    "xmpp_login"                   -> {some={xmpp_login}}
    "ads_management"               -> {some={ads_management}}
    "user_checkins"                -> {some={user_checkins}}
    "friends_about_me"             -> {some={friends_about_me}}
    "friends_activities"           -> {some={friends_activities}}
    "friends_birthday"             -> {some={friends_birthday}}
    "friends_education_history"    -> {some={friends_education_history}}
    "friends_events"               -> {some={friends_events}}
    "friends_groups"               -> {some={friends_groups}}
    "friends_hometown"             -> {some={friends_hometown}}
    "friends_interests"            -> {some={friends_interests}}
    "friends_likes"                -> {some={friends_likes}}
    "friends_location"             -> {some={friends_location}}
    "friends_notes"                -> {some={friends_notes}}
    "friends_online_presence"      -> {some={friends_online_presence}}
    "friends_photo_video_tags"     -> {some={friends_photo_video_tags}}
    "friends_photos"               -> {some={friends_photos}}
    "friends_relationships"        -> {some={friends_relationships}}
    "friends_relationship_details" -> {some={friends_relationship_details}}
    "friends_religion_politics"    -> {some={friends_religion_politics}}
    "friends_status"               -> {some={friends_status}}
    "friends_videos"               -> {some={friends_videos}}
    "friends_website"              -> {some={friends_website}}
    "friends_work_history"         -> {some={friends_work_history}}
    "manage_friendlists"           -> {some={manage_friendlists}}
    "friends_checkins"             -> {some={friends_checkins}}
    "publish_stream"               -> {some={publish_stream}}
    "create_event"                 -> {some={create_event}}
    "rsvp_event"                   -> {some={rsvp_event}}
    "sms"                          -> {some={sms}}
    "offline_access"               -> {some={offline_access}}
    "publish_checkins"             -> {some={publish_checkins}}
    "manage_pages"                 -> {some={manage_pages}}
    _                              -> none

  empty_feed = {
    from        = ""
    to          = ""
    message     = ""
    link        = ""
    picture     = ""
    source      = ""
    name        = ""
    caption     = ""
    description = ""
    properties  = []
    actions     = []
  } : Facebook.feed

}}
