package com.unhurdle.spectrum
{
  import org.apache.royale.events.Event;
  COMPILE::JS
  {
    import org.apache.royale.html.util.addElementToWrapper;
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.elements.Div;
  }
    import com.unhurdle.spectrum.const.IconType;
    import org.apache.royale.core.IChild;

  [Event(name="modalShown", type="org.apache.royale.events.Event")]
  [Event(name="modalHidden", type="org.apache.royale.events.Event")]

  public class Dialog extends Group
  {
    /**
     * <inject_script>
     * var link = document.createElement("link"); 
     * link.setAttribute("rel", "stylesheet");
     * link.setAttribute("type", "text/css");
     * link.setAttribute("href", "assets/css/components/dialog/dist.css");
     * document.head.appendChild(link);
     * </inject_script>
     */

    public function Dialog()
    {
      super();
      underlay = new Underlay();
      underlay.hideOnClick = false;
      addBead(underlay);
      addEventListener("modalShown",handleModalShow);
      addEventListener("modalHidden",handleModalHidden);
    }

    public static const ALERT:int = 1;
    public static const REGULAR:int = 2;
    public static const FULLSCREEN:int = 3;
    public static const FULLSCREEN_TAKEOVER:int = 4;
    public static const SMALL:int = 5;
    public static const MEDIUM:int = 6;
    public static const LARGE:int = 7;
    private var underlay:Underlay;
    override protected function getSelector():String{
      return "spectrum-Dialog";
    }

    COMPILE::JS
    private var outerElement:HTMLElement;
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement{
      var elem:WrappedHTMLElement = addElementToWrapper(this,"div");
      outerElement = newElement("div",appendSelector("-wrapper"));
      outerElement.appendChild(elem);
      return elem
    }
    /**
     * The HTMLElement used to position the component.
     * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
     */
    COMPILE::JS
    override public function get positioner():WrappedHTMLElement
    {
        return outerElement as WrappedHTMLElement;
    }

    override public function addedToParent():void{
      super.addedToParent();
      if(dismissible){
        var head:DialogHeader = getHeaderElement();
        head.addElementAt(getCloseButton(),head.numElements);
      }
    }
    private var headerElem:DialogHeader;
    private function getHeaderElement():DialogHeader{
      if(!headerElem){
        for(var i:int=0;i<numElements;i++){
          var elem:IChild = getElementAt(i);
          if(elem is DialogHeader){
            headerElem = elem as DialogHeader;
            break;
          }
        }
        if(!headerElem){
          headerElem = new DialogHeader();
          var position:int = hero ? 1 : 0;
          addElementAt(headerElem,position);
        }
      }
      return headerElem
    }
    private var _closeButton:ActionButton;
    private function getCloseButton():ActionButton{
      if(!_closeButton){
        _closeButton = new ActionButton();
        _closeButton.quiet = true;
        _closeButton.className = appendSelector("-closeButton");
        var type:String = IconType.CROSS_LARGE;
        _closeButton.icon = Icon.getCSSTypeSelector(type);
        _closeButton.iconType = type;
        _closeButton.addEventListener("click",hide);
      }
      return _closeButton;
    }

    private var _size:int;

    public function get size():int
    {
    	return _size;
    }
    private var styleLookup:Array = [
      "",
      "alert",
      "",
      "fullscreen",
      "fullscreenTakeover",
      "small",
      "medium",
      "large"
    ];
    public function set size(value:int):void
    {
      if(value != _size){
        var oldSize:String = styleLookup[_size];
        if(oldSize){
            toggle(valueToSelector(oldSize),false);
        }
        var newSize:String = styleLookup[value];
        if(newSize){
          toggle(valueToSelector(newSize),true);
        }
      }
    	_size = value;
    }
    COMPILE::JS
    private var heroDiv:Div;
    private var _hero:String;

    public function get hero():String
    {
    	return _hero;
    }
    public function set hero(value:String):void
    {
      if(value != !!_hero){
        // toggle(valueToSelector("hero"),value);
        COMPILE::JS{
          if(value){
            if(!heroDiv){
              heroDiv = new Div();
              heroDiv.className = appendSelector("-hero");
              addElementAt(heroDiv,0);
            }
            heroDiv.element.style.backgroundImage="url("+ value + ")";
          }else{
            removeElement(heroDiv);
            heroDiv = null;
          }
        }
      }
    	_hero = value;
    }
    private var _dismissible:Boolean;

    public function get dismissible():Boolean
    {
    	return _dismissible;
    }
    public function set dismissible(value:Boolean):void
    {
      if(value != !!_dismissible){
        toggle(valueToSelector("dismissible"),value);
        COMPILE::JS{
          // already added, so we need to update elements
          if(parent){
            if(value){
              var head:DialogHeader = getHeaderElement();
              head.addElementAt(getCloseButton(),head.numElements);
            } else {
              if(_closeButton && _closeButton.parent){
                _closeButton.parent.removeElement(_closeButton);
              }
            }
          }
        }          
      }
    	_dismissible = value;
    }
    private var _noDivider:Boolean;

    public function get noDivider():Boolean
    {
    	return _noDivider;
    }

    public function set noDivider(value:Boolean):void
    {
      if(value != !!_noDivider){
        toggle(valueToSelector("noDivider"),value);
      }
    	_noDivider = value;
    }

    public function get easyDismiss():Boolean
    {
    	return underlay.hideOnClick;
    }

    public function set easyDismiss(value:Boolean):void
    {
    	underlay.hideOnClick = value;
    }
    private var _error:Boolean;

    public function get error():Boolean
    {
    	return _error;
    }

    public function set error(value:Boolean):void
    {
      if(value != !!_error){
        toggle(valueToSelector("error"),value);
      }
    	_error = value;
    }
    private var _success:Boolean;

    public function get success():Boolean
    {
    	return _success;
    }

    public function set success(value:Boolean):void
    {
      if(value != !!_success){
        toggle(valueToSelector("success"),value);
      }
    	_success = value;
    }
    private var attachedToApp:Boolean;
    public function show():void{
      Application.current.popUpParent.addElement(this);
      visible = true;
      dispatchEvent(new Event("modalShown"));
    }
    private function handleModalShow(ev:Event):void{
        toggle("is-open",true);
    }
    public function hide():void
    {
      visible = false;
      toggle("is-open",false);
      parent.removeElement(this);
      dispatchEvent(new Event("modalHidden"));
      dispatchEvent(new Event("hide"));
    }
    private function handleModalHidden(ev:Event):void{
      toggle("is-open",false);
    }
  }
}