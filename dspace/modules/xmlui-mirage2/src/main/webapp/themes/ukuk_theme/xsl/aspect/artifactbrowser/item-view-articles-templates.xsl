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
    
    <xsl:template name="itemSummaryView-DIM-articles-DOI">
	<xsl:if test="dim:field[@element='identifier'][@qualifier='doi']">
	    	<!-- Store DOI in variable for later use -->    
		<xsl:variable name="doi-url"><xsl:value-of select="dim:field[@element='identifier'][@qualifier='doi']"/></xsl:variable>

		<div class="simple-item-view-doi item-page-field-wrapper table">
			<h4 class="item-view-heading">DOI</h4>
			<a href="https://doi.org/{$doi-url}" target="_blank"><xsl:value-of select="dim:field[@element='identifier'][@qualifier='doi']"/></a>
		</div>
	</xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-articles-ISSN">

    	<div class="simple-item-view-contributors item-page-field-wrapper table">
            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-issn</i18n:text></h4>
            <xsl:choose>
            	<xsl:when test="dim:field[@element='identifier'][@qualifier='issn']">
            		<xsl:value-of select="dim:field[@element='identifier'][@qualifier='issn']"/>
            	</xsl:when>
            	<xsl:otherwise>
            		<xsl:choose>
            			<xsl:when test="$active-locale='cs'">
            				<xsl:text>Informace není k dispozici</xsl:text>
            			</xsl:when>
            			<xsl:when test="$active-locale='en'">
            				<xsl:text>Information unavailable</xsl:text>
            			</xsl:when>
            			<xsl:otherwise>
            				<xsl:text>Information unavailable</xsl:text>
            			</xsl:otherwise>
            		</xsl:choose>
            	</xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-periodical-source">
    	<div class="simple-item-view-source-uri item-page-field-wrapper table">
    		<h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-source-periodical</i18n:text></h4>
    		<xsl:call-template name="itemSummaryView-DIM-general-source-data"/>
    	</div>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-periodical-source-url">
        <div class="simple-item-view-source-uri item-page-field-wrapper table">
            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-source-periodical-uri</i18n:text></h4>
            <xsl:call-template name="itemSummaryView-DIM-general-source-url-data"/>
        </div>
    </xsl:template>

</xsl:stylesheet>

