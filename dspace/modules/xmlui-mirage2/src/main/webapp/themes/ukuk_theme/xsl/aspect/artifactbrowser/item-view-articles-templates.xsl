<xsl:stylesheet
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:dri="http://di.tamu.edu/DRI/1.0/"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
    xmlns:xlink="http://www.w3.org/TR/xlink/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:oreatom="http://www.openarchives.org/ore/atom/"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:encoder="xalan://java.net.URLEncoder"
    xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
    xmlns:jstring="java.lang.String"
    xmlns:rights="http://cosimo.stanford.edu/sdr/metsrights/"
    xmlns:confman="org.dspace.core.ConfigurationManager"
    exclude-result-prefixes="xalan encoder i18n dri mets dim xlink xsl util jstring rights confman">
    <xsl:import href="item-view-general-templates.xsl" />
    
    <!-- <xsl:template name="itemSummaryView-DIM-articles-DOI"> -->
	<!-- <xsl:if test="dim:field[@element='identifier'][@qualifier='doi']"> -->
	    	<!-- Store DOI in variable for later use -->    
		<!-- <xsl:variable name="doi-url"><xsl:value-of select="dim:field[@element='identifier'][@qualifier='doi']"/></xsl:variable>

		<div class="simple-item-view-doi item-page-field-wrapper table">
			<h4 class="item-view-heading">DOI</h4>
			<a href="https://doi.org/{$doi-url}" target="_blank"><xsl:value-of select="dim:field[@element='identifier'][@qualifier='doi']"/></a>
		</div>
	</xsl:if>
    </xsl:template> -->

    <xsl:template name="itemSummaryView-DIM-publications-identifiers">
    
        <!-- FIXME: Header renders when dc.identifier.citation or dc.identifier.uri are present in metadata, even though their are rendered elsewhere -->
        <xsl:if test="dim:field[@element='identifier'][@qualifier] and descendant::text()">
        
            <xsl:call-template name="itemSummaryView-DIM-publications-identifier-structure"/>

        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-publications-identifier-structure">
        
        <xsl:variable name="tab-id" select="concat('panel-identifiers','-','other-identifiers')"/>
        <xsl:variable name="toggle-href" select="concat('#identifiers-collapse','-','other-identifiers')"/>
        <xsl:variable name="aria-labelled-by" select="concat('identifiers-collapse','-','other-identifiers')"/>
        <xsl:variable name="panel-id" select="concat('identifiers-collapse','-','other-identifiers')"/>
        <xsl:variable name="panel-aria-labelled-by" select="concat('panel-identifiers','-','other-identifiers')"/>
        <xsl:variable name="i18n-message"><xsl:text>xmlui.dri2xhtml.METS-1.0.item-other-identifiers</xsl:text></xsl:variable>

        <div class="simple-item-view-publication-identifiers item-page-field-wrapper table">
            
            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-identifiers</i18n:text></h4>
            

            <div role="tab" id="{$tab-id}">
                <xsl:for-each select="dim:field[@element='identifier'][@qualifier]">
                    <xsl:variable name="qualifier"><xsl:value-of select="@qualifier"/></xsl:variable>
                    <xsl:variable name="id-value"><xsl:value-of select="node()"/></xsl:variable>
                    <xsl:variable name="i18n-text"><xsl:value-of select="concat('xmlui.dri2xhtml.METS-1.0.item-',$qualifier)"/></xsl:variable>
                    
                    <div>
                        <xsl:choose>
                            <xsl:when test="($qualifier= 'issn') or ($qualifier = 'isbn') or ($qualifier = 'doi') or ($qualifier = 'aleph') or ($qualifier = 'obd') or ($qualifier = 'repId')">
                                <span>
                                    <i18n:text><xsl:value-of select="$i18n-text"/></i18n:text><xsl:text>: </xsl:text>

                                    <xsl:call-template name="itemSummaryView-DIM-publications-prefered-identifiers">
                                        <xsl:with-param name="id-data" select="$id-value"/>
                                        <xsl:with-param name="qualifier" select="$qualifier"/>
                                    </xsl:call-template>
                                </span>
                            </xsl:when>
                            <xsl:when test="$qualifier = 'citation'">
                            </xsl:when>
                            <xsl:when test="$qualifier = 'uri'">
                            </xsl:when>
                            <xsl:otherwise>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </xsl:for-each>
                
            </div>
            
        </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-publications-prefered-identifiers">
        <xsl:param name="id-data"/>
        <xsl:param name="qualifier"/>
        <xsl:call-template name="itemSummaryView-DIM-publications-identifier-data">
            <xsl:with-param name="id-data" select="$id-data"/>
            <xsl:with-param name="qualifier" select="$qualifier"/>
        </xsl:call-template>
                
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-publications-identifier-data">
        <!-- TEMPLATE IS RESPONSIBLE FOR COLLECTING IDENTIFIER DATA AND CREATING ACTIVE URL LINK WHERE POSSIBLE -->
        <xsl:param name="id-data"/>
        <xsl:param name="qualifier"/>
        <xsl:choose>
            <xsl:when test="$qualifier = 'doi'">
                <a href="https://doi.org/{$id-data}" target="_blank"><xsl:value-of select="$id-data"/></a>
            </xsl:when>
            <xsl:when test="$qualifier = 'aleph'">
                <a href="https://ckis.cuni.cz:443/F/?func=direct&amp;format=999&amp;doc_number={$id-data}" target="_blank"><xsl:value-of select="$id-data"/></a>
            </xsl:when>
            <xsl:when test="$qualifier = 'repId'">
                <a href="https://is.cuni.cz/studium/dipl_st/index.php?do=main&amp;doo=detail&amp;did={$id-data}" target="_blank"><xsl:value-of select="$id-data"/></a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$id-data"/>
            </xsl:otherwise>
        </xsl:choose>
            
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-publication-source">
    	<div class="simple-item-view-source-uri item-page-field-wrapper table">
    		<h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-source</i18n:text></h4>
    		<xsl:call-template name="itemSummaryView-DIM-general-source-data"/>
    	</div>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-publication-source-url">
        <div class="simple-item-view-source-uri item-page-field-wrapper table">
            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-source-uri</i18n:text></h4>
            <xsl:call-template name="itemSummaryView-DIM-general-source-url-data"/>
        </div>
    </xsl:template>

</xsl:stylesheet>

