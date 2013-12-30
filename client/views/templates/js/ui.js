ui = {};

;(function(exports){
/**
 * Expose `Emitter`.
 */

exports.Emitter = Emitter;

/**
 * Initialize a new `Emitter`.
 * 
 * @api public
 */

function Emitter() {
  this.callbacks = {};
};

/**
 * Listen on the given `event` with `fn`.
 *
 * @param {String} event
 * @param {Function} fn
 * @return {Emitter}
 * @api public
 */

Emitter.prototype.on = function(event, fn){
  (this.callbacks[event] = this.callbacks[event] || [])
    .push(fn);
  return this;
};

/**
 * Adds an `event` listener that will be invoked a single
 * time then automatically removed.
 *
 * @param {String} event
 * @param {Function} fn
 * @return {Emitter}
 * @api public
 */

Emitter.prototype.once = function(event, fn){
  var self = this;

  function on() {
    self.off(event, on);
    fn.apply(this, arguments);
  }

  this.on(event, on);
  return this;
};

/**
 * Remove the given callback for `event` or all
 * registered callbacks.
 *
 * @param {String} event
 * @param {Function} fn
 * @return {Emitter}
 * @api public
 */

Emitter.prototype.off = function(event, fn){
  var callbacks = this.callbacks[event];
  if (!callbacks) return this;

  // remove all handlers
  if (1 == arguments.length) {
    delete this.callbacks[event];
    return this;
  }

  // remove specific handler
  var i = callbacks.indexOf(fn);
  callbacks.splice(i, 1);
  return this;
};

/**
 * Emit `event` with the given args.
 *
 * @param {String} event
 * @param {Mixed} ...
 * @return {Emitter} 
 */

Emitter.prototype.emit = function(event){
  var args = [].slice.call(arguments, 1)
    , callbacks = this.callbacks[event];

  if (callbacks) {
    for (var i = 0, len = callbacks.length; i < len; ++i) {
      callbacks[i].apply(this, args);
    }
  }

  return this;
};

})(ui);

;(function(exports, html){

/**
 * Expose `ColorPicker`.
 */

exports.ColorPicker = ColorPicker;

/**
 * RGB util.
 */

function rgb(r,g,b) {
  return 'rgb(' + r + ', ' + g + ', ' + b + ')';
}

/**
 * RGBA util.
 */

function rgba(r,g,b,a) {
  return 'rgba(' + r + ', ' + g + ', ' + b + ', ' + a + ')';
}

/**
 * Mouse position util.
 */

function localPos(e) {
  var offset = $(e.target).offset();
  return {
      x: e.pageX - offset.left
    , y: e.pageY - offset.top
  };
}

/**
 * Initialize a new `ColorPicker`.
 *
 * Emits:
 *
 *    - `change` with the given color object
 *
 * @api public
 */

function ColorPicker() {
  ui.Emitter.call(this);
  this._colorPos = {};
  this.el = $(html);
  this.main = this.el.find('.main').get(0);
  this.spectrum = this.el.find('.spectrum').get(0);
  $(this.main).bind('selectstart', function(e){ e.preventDefault() });
  $(this.spectrum).bind('selectstart', function(e){ e.preventDefault() });
  this.hue(rgb(255, 0, 0));
  this.spectrumEvents();
  this.mainEvents();
  this.w = 180;
  this.h = 180;
  this.render();
}

/**
 * Inherit from `Emitter.prototype`.
 */

ColorPicker.prototype = new ui.Emitter;

/**
 * Set width / height to `n`.
 *
 * @param {Number} n
 * @return {ColorPicker} for chaining
 * @api public
 */

ColorPicker.prototype.size = function(n){
  return this
    .width(n)
    .height(n);
};

/**
 * Set width to `n`.
 *
 * @param {Number} n
 * @return {ColorPicker} for chaining
 * @api public
 */

ColorPicker.prototype.width = function(n){
  this.w = n;
  this.render();
  return this;
};

/**
 * Set height to `n`.
 *
 * @param {Number} n
 * @return {ColorPicker} for chaining
 * @api public
 */

ColorPicker.prototype.height = function(n){
  this.h = n;
  this.render();
  return this;
};

/**
 * Spectrum related events.
 *
 * @api private
 */

ColorPicker.prototype.spectrumEvents = function(){
  var self = this
    , canvas = $(this.spectrum)
    , down;

  function update(e) {
    var offsetY = localPos(e).y
      , color = self.hueAt(offsetY - 4);
    self.hue(color.toString());
    self.emit('change', color);
    self._huePos = offsetY;
    self.render();
  }

  canvas.mousedown(function(e){
    e.preventDefault();
    down = true;
    update(e);
  });

  canvas.mousemove(function(e){
    if (down) update(e);
  });

  canvas.mouseup(function(){
    down = false;
  });
};

/**
 * Hue / lightness events.
 *
 * @api private
 */

ColorPicker.prototype.mainEvents = function(){
  var self = this
    , canvas = $(this.main)
    , down;

  function update(e) {
    var color;
    self._colorPos = localPos(e);
    color = self.colorAt(self._colorPos.x, self._colorPos.y);
    self.color(color.toString());
    self.emit('change', color);

    self.render();
  }

  canvas.mousedown(function(e){
    down = true;
    update(e);
  });

  canvas.mousemove(function(e){
    if (down) update(e);
  });

  canvas.mouseup(function(){
    down = false;
  });
};

/**
 * Get the RGB color at `(x, y)`.
 *
 * @param {Number} x
 * @param {Number} y
 * @return {Object}
 * @api private
 */

ColorPicker.prototype.colorAt = function(x, y){
  var data = this.main.getContext('2d').getImageData(x, y, 1, 1).data;
  return {
      r: data[0]
    , g: data[1]
    , b: data[2]
    , toString: function(){
      return rgb(this.r, this.g, this.b);
    }
  };
};

/**
 * Get the RGB value at `y`.
 *
 * @param {Type} name
 * @return {Type}
 * @api private
 */

ColorPicker.prototype.hueAt = function(y){
  var data = this.spectrum.getContext('2d').getImageData(0, y, 1, 1).data;
  return {
      r: data[0]
    , g: data[1]
    , b: data[2]
    , toString: function(){
      return rgb(this.r, this.g, this.b);
    }
  };
};

/**
 * Get or set `color`.
 *
 * @param {String} color
 * @return {String|ColorPicker}
 * @api public
 */

ColorPicker.prototype.color = function(color){
  // TODO: update pos
  if (0 == arguments.length) return this._color;
  this._color = color;
  return this;
};

/**
 * Get or set hue `color`.
 *
 * @param {String} color
 * @return {String|ColorPicker}
 * @api public
 */

ColorPicker.prototype.hue = function(color){
  // TODO: update pos
  if (0 == arguments.length) return this._hue;
  this._hue = color;
  return this;
};

/**
 * Render with the given `options`.
 *
 * @param {Object} options
 * @api public
 */

ColorPicker.prototype.render = function(options){
  options = options || {};
  this.renderMain(options);
  this.renderSpectrum(options);
};

/**
 * Render spectrum.
 *
 * @api private
 */

ColorPicker.prototype.renderSpectrum = function(options){
  var el = this.el
    , canvas = this.spectrum
    , ctx = canvas.getContext('2d')
    , pos = this._huePos
    , w = this.w * .12
    , h = this.h;

  canvas.width = w;
  canvas.height = h;

  var grad = ctx.createLinearGradient(0, 0, 0, h);
  grad.addColorStop(0, rgb(255, 0, 0));
  grad.addColorStop(.15, rgb(255, 0, 255));
  grad.addColorStop(.33, rgb(0, 0, 255));
  grad.addColorStop(.49, rgb(0, 255, 255));
  grad.addColorStop(.67, rgb(0, 255, 0));
  grad.addColorStop(.84, rgb(255, 255, 0));
  grad.addColorStop(1, rgb(255, 0, 0));

  ctx.fillStyle = grad;
  ctx.fillRect(0, 0, w, h);

  // pos
  if (!pos) return;
  ctx.fillStyle = rgba(0,0,0, .3);
  ctx.fillRect(0, pos, w, 1);
  ctx.fillStyle = rgba(255,255,255, .3);
  ctx.fillRect(0, pos + 1, w, 1);
};

/**
 * Render hue/luminosity canvas.
 *
 * @api private
 */

ColorPicker.prototype.renderMain = function(options){
  var el = this.el
    , canvas = this.main
    , ctx = canvas.getContext('2d')
    , w = this.w
    , h = this.h
    , x = (this._colorPos.x || w) + .5
    , y = (this._colorPos.y || 0) + .5;

  canvas.width = w;
  canvas.height = h;

  var grad = ctx.createLinearGradient(0, 0, w, 0);
  grad.addColorStop(0, rgb(255, 255, 255));
  grad.addColorStop(1, this._hue);

  ctx.fillStyle = grad;
  ctx.fillRect(0, 0, w, h);

  grad = ctx.createLinearGradient(0, 0, 0, h);
  grad.addColorStop(0, rgba(255, 255, 255, 0));
  grad.addColorStop(1, rgba(0, 0, 0, 1));

  ctx.fillStyle = grad;
  ctx.fillRect(0, 0, w, h);

  // pos
  var rad = 10;
  ctx.save();
  ctx.beginPath();
  ctx.lineWidth = 1;

  // outer dark
  ctx.strokeStyle = rgba(0,0,0,.5);
  ctx.arc(x, y, rad / 2, 0, Math.PI * 2, false);
  ctx.stroke();

  // outer light
  ctx.strokeStyle = rgba(255,255,255,.5);
  ctx.arc(x, y, rad / 2 - 1, 0, Math.PI * 2, false);
  ctx.stroke();

  ctx.beginPath();
  ctx.restore();
};
})(ui, "<div class=\"color-picker\">\n  <canvas class=\"main\"></canvas>\n  <canvas class=\"spectrum\"></canvas>\n</div>");
;(function(exports, html){

/**
 * Notification list.
 */

var list;

/**
 * Expose `Notification`.
 */

exports.Notification = Notification;

// list

$(function(){
  list = $('<ul id="notifications">');
  list.appendTo('body');
})

/**
 * Return a new `Notification` with the given 
 * (optional) `title` and `msg`.
 *
 * @param {String} title or msg
 * @param {String} msg
 * @return {Dialog}
 * @api public
 */

exports.notify = function(title, msg){
  switch (arguments.length) {
    case 2:
      return new Notification({ title: title, message: msg })
        .show()
        .hide(4000);
    case 1:
      return new Notification({ message: title })
        .show()
        .hide(4000);
  }
};

/**
 * Construct a notification function for `type`.
 *
 * @param {String} type
 * @return {Function}
 * @api private
 */

function type(type) {
  return function(title, msg){
    return exports.notify.apply(this, arguments)
      .type(type);
  }
}

/**
 * Notification methods.
 */

exports.info = exports.notify;
exports.warn = type('warn');
exports.error = type('error');

/**
 * Initialize a new `Notification`.
 *
 * Options:
 *
 *    - `title` dialog title
 *    - `message` a message to display
 *
 * @param {Object} options
 * @api public
 */

function Notification(options) {
  ui.Emitter.call(this);
  options = options || {};
  this.template = html;
  this.el = $(this.template);
  this.render(options);
  if (Notification.effect) this.effect(Notification.effect);
};

/**
 * Inherit from `Emitter.prototype`.
 */

Notification.prototype = new ui.Emitter;

/**
 * Render with the given `options`.
 *
 * @param {Object} options
 * @api public
 */

Notification.prototype.render = function(options){
  var el = this.el
    , title = options.title
    , msg = options.message
    , self = this;

  el.find('.close').click(function(){
    self.hide();
    return false;
  });

  el.click(function(e){
    e.preventDefault();
    self.emit('click', e);
  });

  el.find('h1').text(title);
  if (!title) el.find('h1').remove();

  // message
  if ('string' == typeof msg) {
    el.find('p').text(msg);
  } else if (msg) {
    el.find('p').replaceWith(msg.el || msg);
  }

  setTimeout(function(){
    el.removeClass('hide');
  }, 0);
};

/**
 * Enable the dialog close link.
 *
 * @return {Notification} for chaining
 * @api public
 */

Notification.prototype.closable = function(){
  this.el.addClass('closable');
  return this;
};

/**
 * Set the effect to `type`.
 *
 * @param {String} type
 * @return {Notification} for chaining
 * @api public
 */

Notification.prototype.effect = function(type){
  this._effect = type;
  this.el.addClass(type);
  return this;
};

/**
 * Show the notification.
 *
 * @return {Notification} for chaining
 * @api public
 */

Notification.prototype.show = function(){
  this.el.appendTo(list);
  return this;
};

/**
 * Set the notification `type`.
 *
 * @param {String} type
 * @return {Notification} for chaining
 * @api public
 */

Notification.prototype.type = function(type){
  this._type = type;
  this.el.addClass(type);
  return this;
};

/**
 * Make it stick (clear hide timer), and make it closable.
 *
 * @return {Notification} for chaining
 * @api public
 */

Notification.prototype.sticky = function(){
  return this.hide(0).closable();
};

/**
 * Hide the dialog with optional delay of `ms`,
 * otherwise the notification is removed immediately.
 *
 * @return {Number} ms
 * @return {Notification} for chaining
 * @api public
 */

Notification.prototype.hide = function(ms){
  var self = this;

  // duration
  if ('number' == typeof ms) {
    clearTimeout(this.timer);
    if (!ms) return this;
    this.timer = setTimeout(function(){
      self.hide();
    }, ms);
    return this;
  }

  // hide / remove
  this.el.addClass('hide');
  if (this._effect) {
    setTimeout(function(self){
      self.remove();
    }, 500, this);
  } else {
    self.remove();
  }

  return this;
};

/**
 * Hide the notification without potential animation.
 *
 * @return {Dialog} for chaining
 * @api public
 */

Notification.prototype.remove = function(){
  this.el.remove();
  return this;
};
})(ui, "<li class=\"notification hide\">\n  <div class=\"content\">\n    <h1>Title</h1>\n    <a href=\"#\" class=\"close\">×</a>\n    <p>Message</p>\n  </div>\n</li>");
;(function(exports, html){

/**
 * Expose `Menu`.
 */

exports.Menu = Menu;

/**
 * Create a new `Menu`.
 *
 * @return {Menu}
 * @api public
 */

exports.menu = function(){
  return new Menu();
};

/**
 * Initialize a new `Menu`.
 *
 * Emits:
 *
 *   - "show" when shown
 *   - "hide" when hidden
 *   - "remove" with the item name when an item is removed
 *   - * menu item events are emitted when clicked
 *
 * @api public
 */

function Menu() {
  ui.Emitter.call(this);
  this.items = {};
  this.el = $(html).hide().appendTo('body');
  this.el.hover(this.deselect.bind(this));
  $('html').click(this.hide.bind(this));
  this.on('show', this.bindKeyboardEvents.bind(this));
  this.on('hide', this.unbindKeyboardEvents.bind(this));
};

/**
 * Inherit from `Emitter.prototype`.
 */

Menu.prototype = new ui.Emitter;

/**
 * Deselect selected menu items.
 *
 * @api private
 */

Menu.prototype.deselect = function(){
  this.el.find('.selected').removeClass('selected');
};

/**
 * Bind keyboard events.
 *
 * @api private
 */

Menu.prototype.bindKeyboardEvents = function(){
  $(document).bind('keydown.menu', this.onkeydown.bind(this));
  return this;
};

/**
 * Unbind keyboard events.
 *
 * @api private
 */

Menu.prototype.unbindKeyboardEvents = function(){
  $(document).unbind('keydown.menu');
  return this;
};

/**
 * Handle keydown events.
 *
 * @api private
 */

Menu.prototype.onkeydown = function(e){
  switch (e.keyCode) {
    // up
    case 38:
      e.preventDefault();
      this.move('prev');
      break;
    // down
    case 40:
      e.preventDefault();
      this.move('next');
      break;
  }
};

/**
 * Focus on the next menu item in `direction`.
 * 
 * @param {String} direction "prev" or "next"
 * @api public
 */

Menu.prototype.move = function(direction){
  var prev = this.el.find('.selected').eq(0);

  var next = prev.length
    ? prev[direction]()
    : this.el.find('li:first-child');

  if (next.length) {
    prev.removeClass('selected');
    next.addClass('selected');
    next.find('a').focus();
  }
};

/**
 * Add menu item with the given `text` and optional callback `fn`.
 *
 * When the item is clicked `fn()` will be invoked
 * and the `Menu` is immediately closed. When clicked
 * an event of the name `text` is emitted regardless of
 * the callback function being present.
 *
 * @param {String} text
 * @param {Function} fn
 * @return {Menu}
 * @api public
 */

Menu.prototype.add = function(text, fn){
  var self = this
    , el = $('<li><a href="#">' + text + '</a></li>')
    .addClass(slug(text))
    .appendTo(this.el)
    .click(function(e){
      e.preventDefault();
      e.stopPropagation();
      self.hide();
      self.emit(text);
      fn && fn();
    });

  this.items[text] = el;
  return this;
};

/**
 * Remove menu item with the given `text`.
 *
 * @param {String} text
 * @return {Menu}
 * @api public
 */

Menu.prototype.remove = function(text){
  var item = this.items[text];
  if (!item) throw new Error('no menu item named "' + text + '"');
  this.emit('remove', text);
  item.remove();
  delete this.items[text];
  return this;
};

/**
 * Check if this menu has an item with the given `text`.
 *
 * @param {String} text
 * @return {Boolean}
 * @api public
 */

Menu.prototype.has = function(text){
  return !! this.items[text];
};

/**
 * Move context menu to `(x, y)`.
 *
 * @param {Number} x
 * @param {Number} y
 * @return {Menu}
 * @api public
 */

Menu.prototype.moveTo = function(x, y){
  this.el.css({
    top: y,
    left: x
  });
  return this;
};

/**
 * Show the menu.
 *
 * @return {Menu}
 * @api public
 */

Menu.prototype.show = function(){
  this.emit('show');
  this.el.show();
  return this;
};

/**
 * Hide the menu.
 *
 * @return {Menu}
 * @api public
 */

Menu.prototype.hide = function(){
  this.emit('hide');
  this.el.hide();
  return this;
};

/**
 * Generate a slug from `str`.
 *
 * @param {String} str
 * @return {String}
 * @api private
 */

function slug(str) {
  return str
    .toLowerCase()
    .replace(/ +/g, '-')
    .replace(/[^a-z0-9-]/g, '');
}

})(ui, "<div class=\"menu\">\n</div>");