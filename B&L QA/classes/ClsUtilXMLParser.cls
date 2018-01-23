/**
 * 
 *   Utility class to parse XML data(in the form of string) and create custom objects.
 *   Makes it easy to read the data. 
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|----------------------------------------|-----------|--------------------------------------------------
 *   Balaji             |balaji.prabakaran@listertechnologies.com|17.04.2010 |First Draft
 *
 */
public with sharing class ClsUtilXMLParser {
  
  ClsUtilXMLElement curParent = new ClsUtilXMLElement();
  ClsUtilXMLElement curElement = new ClsUtilXMLElement();  
  
  private void readElement(XmlStreamReader reader){
    if (reader.isCharacters()){
      curElement.getParent().addAttribute(curElement.getLocalName(), reader.getText().trim());
    }else if (reader.isStartElement()){
      curParent = curElement;
      curElement = new ClsUtilXMLElement();
      curElement.setParent(curParent);
      curElement.setLocalName(reader.getLocalName());
      for (Integer i=0; i<reader.getAttributeCount();i++){
        curElement.addAttribute(reader.getAttributeLocalName(i), reader.getAttributeValueAt(i).trim());
      }
    }else if (reader.isEndElement()){
      if (curElement.getAttrs().size()>0 || curElement.getElements().size()>0){
        curParent.addElement(curElement);
      }
      curElement = curParent;
      curParent = curElement.getParent();
    }
  }
  
  /*
   *  Parses the string input(data as XML) and forms an object of ClsUtilXMLElement
   *  Calls the readElement method recursively to parse through multi-level of data. 
   *
   */
  public ClsUtilXMLElement parse(String input){
    XmlStreamReader reader = new XmlStreamReader(input);
    ClsUtilXMLElement root = null;
        try {
      root = new ClsUtilXMLElement('Root_Element');
      curElement = root;
      curParent = null;
      while(reader.hasNext()){
        readElement(reader);
        reader.next();
      }
    } catch (Exception e) {
      System.debug(e);
      //throw new WS_Exceptions.MalformedXMLException();
    }
    return root.getElements().get(0);
  }
  
  public static String toXML(List<ClsUtilXMLElement> resElements){
    String returnValue='';
    for (ClsUtilXMLElement element:resElements){
      returnValue += element.toXML();
    }
    return returnValue;    
  }
  
}