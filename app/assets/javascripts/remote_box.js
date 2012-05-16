$(function() {
  var application;
  $.application = application = {

    global_interval_handler: null,

    // Make sure that every Ajax request sends the CSRF token
    CSRFProtection: function(xhr) {
      var token = $('meta[name="csrf-token"]').attr('content');
      if (token) xhr.setRequestHeader('X-CSRF-Token', token);
    },

    findParent: function(child, parent_tag) {
      while(child.length > 0){
        if(child.is(parent_tag)){
          return child;
        }
        child = child.parent();
      }
      return null;
    },

    startPoller: function(load_func, millisecond) {
      application.stopPoller();
      load_func();
      application.global_interval_handler = setInterval(load_func,millisecond);
    },

    stopPoller: function() {
      if(application.global_interval_handler){
        clearInterval(application.global_interval_handler);
        application.global_interval_handler = null;
      } 
    },

    load_toggle: function(node,url){
      if(node.html()==""){
        node.html("开始每5秒自动刷新......");
        application.startPoller(function(){
          $.ajax({
            url: url,
            success: function(data,status,xhrs){
              node.html(data);
            }
          });
        },5000);
      }else{
        application.stopPoller();
        node.empty();
      }
    },

    refresh: function(node,url){
      $.ajax({
        url: url,
        success: function(data,status,xhrs){
          node.html(data);
        }
      });
    },
    link: function(node){
      if(node.data('box-href')==null){
        node.data("box-href",node.attr('box-href'));
      }
      return node.data('box-href');
    },
    stopEverything: function(e) {
      $(e.target).trigger('ujs:everythingStopped');
      e.stopImmediatePropagation();
      return false;
    }
  };

  if ('ajaxPrefilter' in $) {
    $.ajaxPrefilter(function(options, originalOptions, xhr){
      if ( !options.crossDomain ) { application.CSRFProtection(xhr); }
    });
  } else {
    $(document).ajaxSend(function(e, xhr, options){
      if ( !options.crossDomain ) { application.CSRFProtection(xhr); }
    });
  }
  
  
  $('div[box-href],li[box-href]').live('load_toggle.application', function(e) {
    var base_node = $(e.currentTarget);
    application.load_toggle(
      base_node,
      application.link(base_node)
    );
    return application.stopEverything(e);
  });
  $('div[box-href],li[box-href]').live('refresh.application', function(e) {
    var base_node = $(e.currentTarget);
    application.refresh(
      base_node,
      application.link(base_node)
    );
    return application.stopEverything(e);
  });
  $('a[handle]').live('ajax:success', function(e, data, status, xhr) {
    var node = $(e.currentTarget).parent();
    var parent = application.findParent(node,'div[box-href],li[box-href]');
    if(parent){
      parent.trigger("refresh.application");
    }
    return application.stopEverything(e);
  });
  $('ul a[select]').live('click', function(e) {
    var node = $(e.currentTarget);
    var checked = node.attr('select')=="all";
    var ul_node = application.findParent(node,'ul');
    if(ul_node){
      ul_node.find('li input[type=checkbox]').each(function(index,input_ele){
        input_ele.checked = checked;
      });
    }
    return application.stopEverything(e);
  });

  $('a[form_to]').live('click',function(e){
    var node = $(e.currentTarget);
    var form = document.forms[node.attr('form_to')];
    
    if(form){
      if(node.attr('prompt')){
        var value = '';
        while(value==''){
          value = '';
          value = window.prompt(node.attr('prompt'));
          if( value == undefined ){
            return application.stopEverything(e);
          }
          if( value == '' ){
            alert('输入内容不能为空');
          }else{
            break;
          }
        }
        form.data.value = value;
      }
      form.action = node.attr('href');
      $(form).trigger('submit.rails');
    }
    return application.stopEverything(e);
  });

  $('select[box-remote]').live('change',function(e){
    if(this.selectedIndex == -1){
      return application.stopEverything(e);
    }//如果没有选中，则不作任何处理
    var element = $(this);
    var url = element.attr('url'),
      method = element.attr('method'),
      option = this.options[this.selectedIndex],
      name = this.name;

    var data = name + "=" + option.value;
		if (element.data('params')) data = data + "&" + element.data('params'); 
					
    var options = {
      url: url, type: method || 'GET', data: data
    };

    $.ajax(options);
    return application.stopEverything(e);
  });
  
  $('div[lazy=true]').trigger("refresh.application");
});

