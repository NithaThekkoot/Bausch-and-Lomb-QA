/**
 * 
 *   Class to represent XML data. 
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|----------------------------------------|-----------|--------------------------------------------------
 *   Balaji             |balaji.prabakaran@listertechnologies.com|17.04.2010 |First Draft
 *
 */
 
public with sharing class ClsUtilXMLElement {
  
  private String localName;  //The tag name.
  private Map<String, String> attrs = new Map<String, String>(); //The attributes of a tag as name-value pairs
  private Map<String, String> params = new Map<String, String>(); //The parameters of a tag as name-value pairs 
  private List<ClsUtilXMLElement> elements = new List<ClsUtilXMLElement>(); //List of sub tags of a tag
  private ClsUtilXMLElement parent = null; // The parent tag of a given tag
  
  public ClsUtilXMLElement() {
    this.localName = '';
  }

  public ClsUtilXMLElement(String localName) {
    this.localName = localName;
  }

  public String getLocalName() {
    return localName;
  }
  
  public void setLocalName(String localName) {
    this.localName = localName;
  }
  
  public Map<String, String> getAttrs() {
    return attrs;
  }
  
  public void setAttrs(Map<String, String> attrs) {
    this.attrs = attrs;
  }

  public Map<String, String> getParams() {
    return params;
  }
  
  public void setParams(Map<String, String> params) {
    this.params = params;
  }

  public List<ClsUtilXMLElement> getElements() {
    return elements;
  }

  public void setElements(List<ClsUtilXMLElement> elements) {
    this.elements = elements;
  }

  public void setParent(ClsUtilXMLElement parent) {
    this.parent = parent;
  }
  
  public ClsUtilXMLElement getParent() {
    return parent;
  }

  public void addAttribute(String name, String value){
    attrs.put(name, value);
  }

  public void addParameter(String name, String value){
    params.put(name, value);
  }

  public void addElement(ClsUtilXMLElement element){
    elements.add(element);
  }

  //Returns JSON representation of XML Data
  /*public String toMyString() {
    String retValue='[';
    retValue += localName + ',' + attrs + params + ',{';
    for (ClsUtilXMLElement element: elements){
      retValue += element.toMyString();
    }
    retValue += '}]';
    return retValue;
  }*/

  //Returns XML representation of the data.
  public String toXML() {
    String xmlString='';
    xmlString += '<' + localName; 
    for (String attrName:attrs.keySet()){
      xmlString += ' ' + attrName + '="';
      xmlString += attrs.get(attrName); 
      xmlString += '"'; 
    }
    xmlString += '>'; 
    for (String paramName:params.keySet()){
      xmlString += '<' + paramName + '>';
      xmlString += params.get(paramName); 
      xmlString += '</' + paramName + '>'; 
    }
    for (ClsUtilXMLElement element: elements){
      xmlString += element.toXML();
    }
    xmlString += '</' + localName + '>';
    return xmlString;
  }
}