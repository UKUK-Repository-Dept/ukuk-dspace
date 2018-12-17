package org.dspace.ctask.general;

import java.io.IOException;
import java.io.File;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

import org.dspace.content.Metadatum;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.core.Constants;
import org.dspace.core.ConfigurationManager;
import org.dspace.curate.AbstractCurationTask;
import org.dspace.curate.Curator;
import org.dspace.curate.Suspendable;
import org.w3c.dom.Document;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.FactoryConfigurationError;


/**
 *
 * DSpace package ingester would check the assigned DSpace document type in
 * dc.type element and mapped a value from different typology that corresponds
 * with assingned DSpace document type
 * a) if the assigned DSpace document type was not found in mapfile,
 *    ingest would fail with an error (this should prevent typos and
 *    generaly not supported DSpace type assignment). Failed ingestion shouldn't
 *    trigger batch ingestion failure.
 * b) if the assigned DSpace document type was found in mapfile, mapped type
 *    would be added to a predefined metadata field of the object and ingest
 *    would continue normally
 *
 * @author jitkanovotna
 */
@Suspendable
public class ExtendMetadata extends AbstractCurationTask
{

    // map of required fields
    private Map<String, List<String>> reqMap = new HashMap<String, List<String>>();
    private static String authLang = "en";
    private static String fileName = "hui.xml";
    private static Logger log = Logger.getLogger(ExtendMetadata.class);

    @Override
    public void init(Curator curator, String taskId) throws IOException
    {
        super.init(curator, taskId);
        report("Initializing!!!");
        authLang = ConfigurationManager.getProperty("default.locale");
        String uri = "file:" + new File(fileName).getAbsolutePath();

        try
        {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setValidating(false);
            factory.setIgnoringComments(true);
            factory.setIgnoringElementContentWhitespace(true);

            DocumentBuilder db = factory.newDocumentBuilder();
            Document doc = db.parse(uri);
            //doNodes(doc);
            //checkValues();
        }
        catch (FactoryConfigurationError fe)
        {
       //     throw new DCInputsReaderException("Cannot create Submission form parser",fe);
        }
        catch (Exception e)
        {
       //     throw new DCInputsReaderException("Error creating submission forms: "+e);
        }
    }

    /**
     * Perform the curation task upon passed DSO
     *
     * @param dso the DSpace object
     * @throws IOException
     */
    @Override
    public int perform(DSpaceObject dso) throws IOException
    {
        if (dso.getType() == Constants.ITEM)
        {
            Item item = (Item)dso;
            StringBuilder sb = new StringBuilder();
            log.debug("type: "+dso.getType() + " " + dso.getTypeText()+ "\n");
            String handle = item.getHandle();
            //možná by šlo nahradit za findAll z Item.java
            //for ()
            //    item.findAll();
            {
                //String sourceMetadata = "dc.type.";
                //String sourceMetadata = "dc.title.";
                String sourceMetadata = "dc.contributor.referee";
                //String sourceMetadata = "dc.creator.";
                //String sourceMetadata = "dc.language.";
                //String sourceMetadata = "uk.habilitation-board.chairman";
                {
                    sourceMetadata = sourceMetadata.trim();
                    String[] fieldSegments = sourceMetadata.split("\\.", -1);
                    //sb.append(fieldSegments[0]+" "+fieldSegments[1]+" "+fieldSegments[2]+" \n");
                    Metadatum[] metadata = item.getMetadata(fieldSegments[0], fieldSegments[1], fieldSegments[2], null);
                    //Metadatum[] metadata = item.getMetadataByMetadataString(sourceMetadata);
                    log.debug("field: " + sourceMetadata);
                    log.debug("key-segment: " + fieldSegments[1]);
                    if (metadata.length == 0)
                        log.debug("value: missing");
                    else {
                        log.debug("lang: " + metadata[0].language);
                        log.debug("value: " + metadata[0].value);
                    }
                    item.addMetadata(fieldSegments[0], fieldSegments[1], fieldSegments[2], authLang, "obsah");

                    try {
                        item.update();
                    }
                    catch(Exception e) {
                        log.error("AU AU AU");
                        //status = Curator.CURATE_ERROR;
                    }



                }
            }
            //report(sb.toString());
            setResult("Done.");
            return Curator.CURATE_SUCCESS;
            //return Curator.CURATE_FAIL;
        }
        else
        {
            setResult("Object skipped");
            return Curator.CURATE_SKIP;
        }
    }
}
