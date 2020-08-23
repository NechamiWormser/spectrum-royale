package com.unhurdle.spectrum
{
   COMPILE::JS
  {
    import org.apache.royale.html.util.addElementToWrapper;
    import org.apache.royale.core.WrappedHTMLElement;
  }
  public class Link extends Group
  {
    /**
     * <inject_script>
     * var link = document.createElement("link"); 
     * link.setAttribute("rel", "stylesheet");
     * link.setAttribute("type", "text/css");
     * link.setAttribute("href", "assets/css/components/link/dist.css");
     * document.head.appendSelector(link);
     * </inject_script>
     */
    public function Link()
    {
      super();
      _text = "";
    }
    override protected function getSelector():String{
      return "spectrum-Link";
    }
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement
    {
      anchorElement = addElementToWrapper(this,'a') as HTMLAnchorElement;
      textNode = new TextNode("");
      textNode.element = anchorElement;
      return element;
    }

    private var anchorElement:HTMLAnchorElement;

    private var _text:String;

    public function get text():String
    {
    	return _text;
    }

    public function set text(value:String):void
    {
      if(value != !!_text){
    	  _text = value;
      }
      else if(!_text){
        _text = "link without text";
      }
      textNode.text = _text;
    }
    private var textNode:TextNode;

    private var _overBackground:Boolean;

    public function get overBackground():Boolean
    {
      return overBackground;
    }

    public function set overBackground(value:Boolean):void
    {
      if(value != !!_overBackground){
        toggle(valueToSelector("overBackground"),value);
      }
      _overBackground = value;
    }
    private var _disabled:Object;
    private var _href:String;

    public function get href():String
    {
    	return _href;
    }

    public function set href(value:String):void
    {
     if(value != _href){
      if(value){
      	_href = value;
      } else {
        _href = "#";
        }
        anchorElement.href = _href;
      }
    }

    public function get disabled():Object
    {
    	return _disabled;
    }

    public function set disabled(value:Object):void
    {
      if(value != !!_disabled){
        toggle("is-disabled",value);
      }
    	_disabled = value;
    }
    private var _quiet:Boolean;

    public function get quiet():Boolean
    {
    	return _quiet;
    }

    public function set quiet(value:Boolean):void
    {
      if(_quiet != value){
        toggle(valueToSelector("quiet"),value);
      }
    	_quiet = value;
    }
    private var _subtle:Boolean;

    public function get subtle():Boolean
    {
    	return _subtle;
    }

    public function set subtle(value:Boolean):void
    {
      if(_subtle != value){
        toggle(valueToSelector("subtle"),value);
      }
    	_subtle = value;
    }
  }
}