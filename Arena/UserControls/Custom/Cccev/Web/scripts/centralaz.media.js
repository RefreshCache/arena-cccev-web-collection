(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  ﻿window.CentralAZ = window.CentralAZ || {};

  CentralAZ.Media = CentralAZ.Media || {};

  CentralAZ.Media.Video = (function(_super) {

    __extends(Video, _super);

    function Video() {
      Video.__super__.constructor.apply(this, arguments);
    }

    Video.prototype.initialize = function() {
      return this.set({
        htmlID: "video_" + this.id
      });
    };

    return Video;

  })(Backbone.Model);

  CentralAZ.Media.VideoCollection = (function(_super) {

    __extends(VideoCollection, _super);

    function VideoCollection() {
      VideoCollection.__super__.constructor.apply(this, arguments);
    }

    VideoCollection.prototype.initialize = function() {
      return this.model = CentralAZ.Media.Video;
    };

    VideoCollection.prototype.comparator = function(item) {
      return -item.get('id');
    };

    return VideoCollection;

  })(Backbone.Collection);

  CentralAZ.Media.IndexView = (function(_super) {

    __extends(IndexView, _super);

    function IndexView() {
      this.setElement('#centralaz-vimeo-main');
      this.indexTemplate = '{{#videos}}\n<li id="{{htmlID}}">\n<a href="#!/message/{{id}}" title="{{title}}"><img src="{{thumbnail_medium}}" alt="{{title}}" /></a><br/>\n<strong>{{title}}</strong></br>\n<span>{{upload_date}}</span>\n</li>\n{{/videos}}';
      IndexView.__super__.constructor.apply(this, arguments);
    }

    IndexView.prototype.initialize = function(options) {
      return this.model = options.videos;
    };

    IndexView.prototype.render = function() {
      var $main, jsonData,
        _this = this;
      $main = this.$el;
      jsonData = {
        videos: this.model.toJSON()
      };
      return $main.fadeOut("fast", function() {
        var $ul, renderedHtml;
        $main.empty();
        $ul = $("<ul />");
        renderedHtml = Mustache.to_html(_this.indexTemplate, jsonData);
        $ul.html(renderedHtml);
        $ul.appendTo($main);
        return $main.fadeIn("fast");
      });
    };

    return IndexView;

  })(Backbone.View);

  CentralAZ.Media.MessageView = (function(_super) {

    __extends(MessageView, _super);

    function MessageView() {
      this.setElement('#centralaz-vimeo-main');
      this.itemTemplate = '<div class="centralaz-vimeo-player">\n<h1>{{title}}</h1>\n<iframe src="http://player.vimeo.com/video/{{id}}?title=0&amp;byline=0&amp;portrait=0" width="600" height="338" frameborder="0"></iframe>\n<p>{{description}}</p>\n<span><a href="http://vimeo.com/{{id}}">{{title}}</a> by {{user_name}}.</span>\n<a href="#!/home" title="Back">Back</a>\n</div>';
      MessageView.__super__.constructor.apply(this, arguments);
    }

    MessageView.prototype.initialize = function(options) {
      this.videoEmbed = options.videoEmbed;
      return this.model = options.model;
    };

    MessageView.prototype.render = function() {
      var $main,
        _this = this;
      $main = this.$el;
      return $main.fadeOut("fast", function() {
        var renderedHtml;
        $main.empty();
        renderedHtml = Mustache.to_html(_this.itemTemplate, _this.model.toJSON());
        $main.html(renderedHtml);
        return $main.fadeIn("fast");
      });
    };

    return MessageView;

  })(Backbone.View);

  CentralAZ.Media.MediaApp = (function(_super) {

    __extends(MediaApp, _super);

    function MediaApp() {
      MediaApp.__super__.constructor.apply(this, arguments);
    }

    MediaApp.prototype.routes = {
      "": "index",
      "!/home": "index",
      "!/message/:id": "message",
      "!/latest": "latest"
    };

    MediaApp.prototype.initialize = function(options) {
      this.message = null;
      this.currentVideo = null;
      this.videos = options.collection;
      return this.index = new CentralAZ.Media.IndexView({
        videos: this.videos
      });
    };

    MediaApp.prototype.index = function() {
      return this.index.render();
    };

    MediaApp.prototype.message = function(id) {
      this.currentVideo = this.videos.get(id);
      this.message = new CentralAZ.Media.MessageView({
        model: this.currentVideo
      });
      return this.message.render();
    };

    MediaApp.prototype.latest = function() {
      this.currentVideo = this.videos.at(0);
      this.message = new CentralAZ.Media.MessageView({
        model: this.currentVideo
      });
      return this.message.render();
    };

    return MediaApp;

  })(Backbone.Router);

  CentralAZ.Media.Runner = (function() {

    function Runner(accountID) {
      this.accountID = accountID;
    }

    Runner.prototype.init = function() {
      return $.getJSON("http://vimeo.com/api/v2/" + this.accountID + "/videos.json?callback=?", function(data) {
        window.mediaApp = new CentralAZ.Media.MediaApp({
          collection: new CentralAZ.Media.VideoCollection(data)
        });
        return Backbone.history.start();
      });
    };

    return Runner;

  })();

}).call(this);
