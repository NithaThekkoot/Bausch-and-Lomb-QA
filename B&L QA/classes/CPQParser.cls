global class CPQParser {
     private static final String ELEM_CART = 'cart';
     private static final String ELEM_CART_FIELDS = 'fields';
     private static final String ELEM_CART_LINE = 'cartLine';
     private static final String ELEM_CART_TOTAL_CELLS = 'totalCells';
     private static final String ELEM_CART_DOC = 'cartDocument';

     private static final String ATTRIB_LINE_ID = 'id';
     private static final String ATTRIB_LINE_NUM = 'seqNum';
     private static final String ATTRIB_LINE_TYPE = 'type';
     private static final String ATTRIB_LINE_PARENT = 'parent';
     private static final String ATTRIB_LINE_SUBLINE = 'subline';
     
     private static final String ELEM_DOC_ID = 'id';
     private static final String ELEM_DOC_NAME = 'name';
     private static final String ELEM_DOC_DESCR = 'descr';
     private static final String ELEM_DOC_URL = 'url';

     public Quote quo = null;
     
     public CPQParser(Blob quoteXML) {
         try{
             final XmlStreamReader reader = new XmlStreamReader(quoteXML.toString());
             quo = parseQuote(reader);
         }catch(Exception e){
            System.debug(Logginglevel.ERROR,e);
            throw e;
         }
     }

     public Quote getQuote(){
        return this.quo;
     }

    //-------------------------------------------------------------------//
    //                          PARSE QUOTE XML                          //
    //-------------------------------------------------------------------//

    // Create inner classes Quote, QuoteLine & QuoteDocument for processing
    global class Quote
    {
        private String id;
        private String domain;
        private String release;
        
        private Map<String,String> fields = new Map<String, String>();
        private List<QuoteLine> quoteLines = new List<QuoteLine>();
        private List<QuoteDocument> quoteDocuments = new List<QuoteDocument>();

        global String getId() {return id;}
        global String getDomain() {return domain;}
        global String getRelease() {return release;}        
        global Map<String,String> getFields() {return fields;}
        global Map<String,String> getFieldsWithoutTab() {
            Map<String,String> flds = new Map<String,String>();
            for (String fld : fields.keySet()) {
               final String[] f = fld.split('\\.');
               flds.put((f.size()>0?f[f.size()-1]:fld),fields.get(fld));
            }
            return flds;
        }
        global String getField(String fieldName) {return fields.get(fieldName);}
        global List<QuoteLine> getLines(Integer level) {
            List<QuoteLine> res = new List<QuoteLine>();
            List<QuoteLine> aql = getAllLines();
            for (QuoteLine line : aql)
                 if (line.level==level) res.add(line);
            return res;
        }
        global List<QuoteLine> getLines(String type) {
            List<QuoteLine> res = new List<QuoteLine>();
            List<QuoteLine> aql = getAllLines();
            for (QuoteLine line : aql)
                 if (line.lineType.equals(type)) res.add(line);
            return res;
        }
        global List<QuoteLine> getAllLines() {
            List<QuoteLine> res = new List<QuoteLine>();
            for (QuoteLine line : quoteLines)
                 res.addAll(line.getAllLines(new List<QuoteLine>{line}));
            return res;
        }
    }

    global class QuoteLine
    {
        private String  id;
        private String  lineType;
        private String  seqNum;
        private String  parent;
        private Boolean IsSubline;
        private Integer level;

        private List<QuoteLine> quoteLines = new List<QuoteLine>();
        private Map<String,String> columns = new Map<String, String>();
        
        global String getId() {return id;}
        global String getLineType() {return lineType;}
        global String getSeqNum() {return seqNum;}
        global Boolean getIsSubline() {return IsSubline;}
        global Boolean hasSublines() {return (this.quoteLines.size()>0);}
        global Integer getLevel() {return level;}
        global List<QuoteLine> getSublines() {return quoteLines;}
        global List<QuoteLine> getAllLines(List<QuoteLine> lines) {
            List<QuoteLine> res = new List<QuoteLine>();
            for (QuoteLine line : lines) {
              res.add(line);
              if (line.hasSublines()) {
                  List<QuoteLine> sublines = getAllLines(line.getSublines());
                  for (QuoteLine subline : sublines)
                    res.add(subline);
              }
            }
            return res;
        }
        global Map<String,String> getColumns() {return columns;}
        global String getColumnValue(String colName) {return columns.get(colName);}
    }

    global class QuoteDocument
    {
        private String id;
        private String name;
        private String url;
    }

    // Parse Quote
    private static Quote parseQuote(XmlStreamReader reader)
    {
        Quote quo = new Quote();
        Integer level = 0;
        String val;
        
        while(reader.hasNext())
        {
            if (reader.getEventType() == XmlTag.START_ELEMENT)
            {
                val = '';
                if (reader.getLocalName()==ELEM_CART)
                {
                    quo.domain = reader.getAttributeValue(null, 'domain');
                    quo.id = reader.getAttributeValue(null, 'id');
                    quo.release = reader.getAttributeValue(null, 'release');
                }
                else if (reader.getLocalName()==ELEM_CART_FIELDS)
                    parseQuoteFieldsAndTotals(reader,quo);
                else if (reader.getLocalName()==ELEM_CART_LINE)
                {
                    QuoteLine quoteLine = parseQuoteLine(reader,quo,level);
                    quo.quoteLines.add(quoteLine);
                }
                else if (reader.getLocalName()==ELEM_CART_TOTAL_CELLS)
                    parseQuoteFieldsAndTotals(reader,quo);
                else if (reader.getLocalName()==ELEM_CART_DOC)
                {
                    QuoteDocument quoteDocument = parseQuoteDoc(reader,quo);
                    quo.quoteDocuments.add(quoteDocument);
                }
            }
            else if (reader.getEventType()==XmlTag.END_ELEMENT && reader.getLocalName()==ELEM_CART_LINE)
                break;
            reader.next();
        }
        return quo;
    }

    // Parse Quote Line
    private static QuoteLine parseQuoteLine(XmlStreamReader reader, Quote quote, Integer level)
    {
        QuoteLine quoteLine = new QuoteLine();
        quoteLine.id = reader.getAttributeValue(null, ATTRIB_LINE_ID);
        quoteLine.lineType= reader.getAttributeValue(null, ATTRIB_LINE_TYPE);
        quoteLine.seqNum = reader.getAttributeValue(null, ATTRIB_LINE_NUM);
        quoteLine.parent = reader.getAttributeValue(null, ATTRIB_LINE_PARENT);
        quoteLine.IsSubline = (reader.getAttributeValue(null, ATTRIB_LINE_SUBLINE)!=null && reader.getAttributeValue(null, ATTRIB_LINE_SUBLINE).equals('yes'))?true:false;
        quoteLine.level = level;
        
        System.debug(Logginglevel.INFO,'Parsing line :'+quoteLine.id+' - type ='+quoteLine.lineType+' - seqNum=' +quoteLine.seqNum+ ' - subline :'+quoteLine.IsSubline+ ' - level :'+quoteLine.level);

        String elt;
        String val;

        while(reader.hasNext())
        {
            if (reader.getEventType()==XmlTag.START_ELEMENT)
            {
                 val='';
                 if (reader.getLocalName()==ELEM_CART_LINE)
                 {
                    String lid = reader.getAttributeValue(null, ATTRIB_LINE_ID);
                    if (lid!=null && lid!=quoteLine.id) {
                        QuoteLine quoteSubLine = parseQuoteLine(reader,quote,level+1);
                        quoteLine.quoteLines.add(quoteSubLine);
                    }
                 }
                 else
                    elt = reader.getLocalName();
            }
            else if (reader.getEventType()==XmlTag.CHARACTERS)
                val += (reader.getText().trim().length()>0 ? reader.getText() : '');
            else if (reader.getEventType()==XmlTag.END_ELEMENT && reader.getLocalName()==ELEM_CART_LINE)
                break;
            else if (reader.getEventType()==XmlTag.END_ELEMENT && reader.getLocalName()==elt)
                quoteLine.columns.put(elt, val);
            reader.next();
        }
        return quoteLine;
    }

    // Parse Quote Fields & Total Cells
    private static void parseQuoteFieldsAndTotals(XmlStreamReader reader, Quote quote)
    {
        String elt;
        String val;

        while(reader.hasNext())
        {
            if (reader.getEventType()==XmlTag.START_ELEMENT)
            {
                val = '';
                elt = reader.getLocalName();
            }
            else if (reader.getEventType()==XmlTag.CHARACTERS)
                val += (reader.getText().trim().length()>0 ? reader.getText() : '');
            else if (reader.getEventType()==XmlTag.END_ELEMENT && (reader.getLocalName()==ELEM_CART_TOTAL_CELLS || reader.getLocalName()==ELEM_CART_FIELDS))
                break;
            else if (reader.getEventType()==XmlTag.END_ELEMENT && reader.getLocalName()==elt)
                quote.fields.put(elt, val);
            reader.next();
        }
    }

    // Parse Quote Documents
    private static QuoteDocument parseQuoteDoc(XmlStreamReader reader, Quote cart)
    {
        QuoteDocument quoteDocument = new QuoteDocument();
        String elt;
        String val;

        while(reader.hasNext())
        {
            if (reader.getEventType()==XmlTag.START_ELEMENT)
            {
                val = '';
                elt = reader.getLocalName();
            }
            else if (reader.getEventType()==XmlTag.CHARACTERS)
            {
                val += (reader.getText().trim().length()>0 ? reader.getText() : '');
            }
            else if (reader.getEventType()==XmlTag.END_ELEMENT && reader.getLocalName()==ELEM_CART_DOC)
                break;
            else if (reader.getEventType()==XmlTag.END_ELEMENT)
            {
                if (elt==ELEM_DOC_ID && reader.getLocalName()==elt) quoteDocument.id= val;
                else if (elt==ELEM_DOC_NAME && reader.getLocalName()==elt) quoteDocument.name= val;
                else if (elt==ELEM_DOC_URL && reader.getLocalName()==elt) quoteDocument.url= val;
            }
            reader.next();
        }
        return quoteDocument;
    }

    //------------------------------------------------------------------------------------//
    //                              Unitary Test Methods                                  //
    //------------------------------------------------------------------------------------//

    // Positive test
   
}