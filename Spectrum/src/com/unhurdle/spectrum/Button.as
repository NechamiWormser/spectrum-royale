package com.unhurdle.spectrum
{
  COMPILE::JS
  {
    import org.apache.royale.html.util.addElementToWrapper;
    import org.apache.royale.core.WrappedHTMLElement;
  }


  public class Button extends SpectrumBase
  {
    /**
     * <inject_script>
     * var link = document.createElement("link"); 
     * link.setAttribute("rel", "stylesheet");
     * link.setAttribute("type", "text/css");
     * link.setAttribute("href", "assets/css/components/button/dist.css");
     * document.head.appendChild(link);
     * </inject_script>
     */

    public function Button()
    {
      super();
      flavor = "primary";
      _text = "";
    }

    public static const CTA:String = "cta";
    public static const PRIMARY:String = "primary";
    public static const SECONDARY:String = "secondary";
    public static const WARNING:String = "warning";
    public static const OVER_BACKGROUND:String = "overBackground";

    override protected function getSelector():String{
      return "spectrum-Button";
    }


    private var _text:String;

    public function get text():String
    {
    	return _text;
    }

    public function set text(value:String):void
    {
      if(value != _text){
        textNode.text = value;
      }
    	_text = value;
    }
    private var _icon:String;

    /**
     * Icon selector name
     */
    public function get icon():String
    {
    	return _icon;
    }

    public function set icon(value:String):void
    {
    	_icon = value;
      createIcon(value);
    }

    private var _iconClass:String = "";

    public function get iconClass():String
    {
    	return _iconClass;
    }

    public function set iconClass(value:String):void
    {
    	_iconClass = value;
      if(iconElement){
        iconElement.className = value;
      }
    }
    private var _iconSize:String; "S"

    public function get iconSize():String
    {
    	return _iconSize;
    }

    public function set iconSize(value:String):void
    {
      if(!Icon.validateSize(value)){
        return;
      }
    	_iconSize = value;
      if(iconElement){
        iconElement.size = value;
      }
    }
    private var _iconType:String;

    public function get iconType():String
    {
    	return _iconType;
    }

    public function set iconType(value:String):void
    {
    	_iconType = value;
      if(iconElement){
        iconElement.type = value;
      }
    }
    private var _iconElement:Icon;

    public function get iconElement():Icon
    {
    	return _iconElement;
    }

    public function set iconElement(value:Icon):void
    {
      if(_iconElement){
        removeElement(_iconElement);
      }
    	_iconElement = value;
      if(_iconElement){
        addElementAt(_iconElement,0);
      }
    }

    protected function createIcon(selector:String):void{
      if(_iconElement){
        _iconElement.selector = selector;
        setIconProps();
      } else {
        _iconElement = new Icon(selector);
        setIconProps();
        addElementAt(_iconElement,0);
      }
    }
    protected function setIconProps():void{
      if(iconClass){
        _iconElement.className = iconClass;
      }
      _iconElement.size = iconSize;
      _iconElement.type = iconType;
    }

    private var _flavor:String;

    public function get flavor():String
    {
    	return _flavor;
    }

    [Inspectable(category="General", enumeration="cta,primary,secondary,warning,overBackground", defaultValue="primary")]
    public function set flavor(value:String):void
    {
      if(!value){
        throw new Error("flavor must have a value!");
      }
      if(value != _flavor){
        switch(value){
          case "cta":
          case "primary":
          case "secondary":
          case "warning":
          case "overBackground":
            break;
          default:
            throw new Error("Unexpected flavor: " + value);
        }
        if(_flavor){
          var oldSelector:String = valueToSelector(_flavor);
          toggle(oldSelector,false);
        }
        var newSelector:String = valueToSelector(value);
        toggle(newSelector,true);
      }
    	_flavor = value;
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

    public function get disabled():Boolean
    {
      return (element as HTMLButtonElement).disabled;
    }

    public function set disabled(value:Boolean):void
    {
      (element as HTMLButtonElement).disabled = value;
    }

    private var _invalid:Boolean;

    public function get invalid():Boolean
    {
    	return _invalid;
    }

    public function set invalid(value:Boolean):void
    {
      if(value != !!_invalid){
        toggle("is-invalid",value);
      }
    	_invalid = value;
    }
    
    private var _selected:Boolean;

    public function get selected():Boolean
    {
    	return _selected;
    }

    public function set selected(value:Boolean):void
    {
      if(value != !!_selected){
        toggle("is-selected",value);
      }
    	_selected = value;
    }
    public var textNode:TextNode;

    COMPILE::JS
    override protected function createElement():WrappedHTMLElement{
      addElementToWrapper(this,'button');
      textNode = new TextNode("span");
      textNode.className = appendSelector("-label");
      element.appendChild(textNode.element);
      return element;
    }
  }
}