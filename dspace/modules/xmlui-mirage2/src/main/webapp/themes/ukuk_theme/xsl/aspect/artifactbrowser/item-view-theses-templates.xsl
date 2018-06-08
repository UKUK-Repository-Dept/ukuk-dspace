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

    <!-- <JR> - 22. 2. 2017 -->
    <xsl:template name="itemSummaryView-DIM-theses-defense-status">
        <xsl:if test="dim:field[@element='grade' and @qualifier='cs']">
            <xsl:if test="dim:field[@element='grade' and @qualifier='cs']">
                <xsl:choose>
                    <xsl:when test="node()/text()='Výtečně'">
                        <xsl:text> [</xsl:text><span class="text-theses-defended"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text></span><xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:when test="node()/text()='Výborně'">
                        <xsl:text> [</xsl:text><span class="text-theses-defended"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text></span><xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:when test="node()/text()='Velmi dobře'">
                        <xsl:text> [</xsl:text><span class="text-theses-defended"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text></span><xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:when test="node()/text()='Dobře'">
                        <xsl:text> [</xsl:text><span class="text-theses-defended"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text></span><xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:when test="node()/text()='Prospěl'">
                        <xsl:text> [</xsl:text><span class="text-theses-defended"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text></span><xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> [</xsl:text><span class="text-theses-failed"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-not-defended-item-view</i18n:text></span><xsl:text>]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>