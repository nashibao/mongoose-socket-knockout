// Generated by CoffeeScript 1.6.2
var $, ApplicationViewModel, Model, RestAdapter, SocketAdapter, app, d3_charts, line, message_schema, mgsc, oa, oo, pie, socket,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  _this = this;

require('knockout');

oo = ko.observable;

oa = ko.observableArray;

$ = require('jquery');

mgsc = require('./mongoose-socket-client');

Model = mgsc.Model;

SocketAdapter = mgsc.adapter.socket;

RestAdapter = mgsc.adapter.rest;

message_schema = require('./message/model').message_schema;

d3_charts = require('simple-d3-charts');

pie = d3_charts.pie;

line = d3_charts.line;

app = {};

app.message_schema = message_schema;

socket = SocketAdapter.create_socket('test', io);

ApplicationViewModel = (function() {
  function ApplicationViewModel() {
    this.remove = __bind(this.remove, this);
    this.update = __bind(this.update, this);
    this.create = __bind(this.create, this);
    this.view_page = __bind(this.view_page, this);
    var adapter,
      _this = this;
    adapter = new RestAdapter();
    this.messages_model = new Model({
      name_space: 'test',
      collection_name: 'message',
      model: message_schema,
      adapter: adapter
    });
    this.messages = this.messages_model.find({});
    this.count = this.messages_model.count({});
    this.content = oo("");
    this.pie_chart = false;
    this.line_chart = false;
    $(document).ready(function() {
      _this.pie_chart = new pie("#pie-chart", {
        pie: {
          width: 300,
          height: 300,
          r: 60,
          ir: 30
        }
      });
      return _this.line_chart = new line("#line-chart", {
        width: 600,
        height: 300,
        scale_x: {
          min: 0,
          max: 10
        },
        scale_y: {
          min: 0,
          max: 10
        }
      });
    });
    this.count.val.subscribe(function(d) {
      var nd;
      nd = [
        {
          data_label: 'no',
          data_value: 10 - d
        }, {
          data_label: 'yes',
          data_value: d
        }
      ];
      return _this.pie_chart.update(nd);
    });
    this.message_length = oa([]);
    this._message_length = {};
    this.update_cnt = 0;
    this.messages.docs.subscribe(function(ds) {
      var cnt, d, line_d, removes, val, _i, _j, _k, _len, _len1, _len2, _ref;
      line_d = [];
      _this.update_cnt += 1;
      cnt = 0;
      for (_i = 0, _len = ds.length; _i < _len; _i++) {
        d = ds[_i];
        line_d.push({
          data_label: d.content,
          x: cnt,
          y: d.content.length
        });
        cnt += 1;
        if (d._id in _this._message_length) {
          val = _this._message_length[d._id];
          val.content(d.content.length);
          val.update_cnt = _this.update_cnt;
        } else {
          val = {
            content: oo(d.content.length),
            update_cnt: _this.update_cnt
          };
          _this._message_length[d._id] = val;
          _this.message_length.push(val);
        }
      }
      removes = [];
      _ref = _this.message_length();
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        val = _ref[_j];
        if (val.update_cnt !== _this.update_cnt) {
          removes.push(val);
        }
      }
      for (_k = 0, _len2 = removes.length; _k < _len2; _k++) {
        val = removes[_k];
        _this.message_length.remove(val);
      }
      return _this.line_chart.update(line_d);
    });
  }

  ApplicationViewModel.prototype.view_page = function(page) {
    this.messages.query.page = page;
    return this.messages.update();
  };

  ApplicationViewModel.prototype.create = function() {
    var bl, rnd;
    rnd = Math.floor(Math.random() * 10);
    bl = this.messages_model.create({
      doc: {
        'content': this.content(),
        'number': rnd
      }
    });
    if (bl) {
      return this.content("");
    }
  };

  ApplicationViewModel.prototype.update = function(doc) {
    return this.messages_model.update({
      conditions: {
        '_id': doc._id
      },
      update: doc
    });
  };

  ApplicationViewModel.prototype.remove = function(doc) {
    return this.messages_model.remove({
      conditions: {
        '_id': doc._id
      }
    });
  };

  return ApplicationViewModel;

})();

app.vm = new ApplicationViewModel;

$(document).ready(function() {
  return ko.applyBindings(app.vm);
});

module.exports = app;
