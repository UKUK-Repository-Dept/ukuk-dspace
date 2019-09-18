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
    
    <xsl:template name="itemSummaryView-DIM-carolina-digi-archive-contents">
        <xsl:if test="dim:field[@element='carolinaFormat' and descendant::text()]">
            
            <div class="simple-item-view-file-formats item-page-field-wrapper table">
                <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-archive-contents-formats</i18n:text></h4>
                
                <xsl:for-each select="dim:field[@element='carolinaFormat']">
                    <div>
                        <span>
                            <i18n:text>xmlui.dri2xhtml.mimetype.<xsl:value-of select="." /></i18n:text>                            
                        </span>
                    </div>
                </xsl:for-each>
            </div>

        </xsl:if>
    </xsl:template>

</xsl:stylesheet>

