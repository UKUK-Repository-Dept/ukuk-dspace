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
    
    <xsl:template name="itemSummaryView-DIM-general-title-first">
        <xsl:choose>
            <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                <!--<h2 class="page-header first-page-header item-view-header">-->
                <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
            </xsl:when>
            <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                <!--<h2 class="page-header first-page-header item-view-header">-->
                <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                <!--<xsl:call-template name="itemSummaryView-DIM-title-translated"/>-->
                <!--</h2>-->
            </xsl:when>
            <xsl:otherwise>
                <!--<h2 class="page-header first-page-header">-->
                <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                <!--</h2>-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-general-title-all-other">
        <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
            <xsl:if test="not(position() = 1)">
                <xsl:value-of select="./node()"/>
                <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                    <xsl:text> </xsl:text>
                    <br/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-general-title-translated">
        <xsl:if test="dim:field[@element='title' and @qualifier='translated']">
            <xsl:value-of select="dim:field[@element='title' and @qualifier='translated']"/>
        </xsl:if>
    </xsl:template>

    <!-- <JR> - 20. 2. 2017 -->
    <xsl:template name="itemSummaryView-DIM-general-work-type">
        <xsl:choose>
            <xsl:when test="$active-locale='en'">
                <xsl:choose>
                    <xsl:when test="dim:field[@element='type' and @language='en_US']">
                        <xsl:value-of select="dim:field[@element='type' and @language='en_US']" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='type']">
                                <xsl:value-of select="dim:field[@element='type']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Unknown document type</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$active-locale='cs'">
                <xsl:choose>
                    <xsl:when test="dim:field[@element='type' and @language='cs_CZ']">
                        <xsl:value-of select="dim:field[@element='type' and @language='cs_CZ']" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='type']">
                                <xsl:value-of select="dim:field[@element='type']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Neznámý typ dokumentu</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="dim:field[@element='type' and @language='en_US']">
                        <xsl:value-of select="dim:field[@element='type' and @language='en_US']" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='type']">
                                <xsl:value-of select="dim:field[@element='type']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Unknown document type</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- <JR> - 22. 2. 2017 -->
    <xsl:template name="itemSummaryView-DIM-general-defense-status">
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

    <xsl:template name="itemSummaryView-DIM-general-file-section">
        <xsl:choose>
            <xsl:when test="//mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
                <div class="item-page-field-wrapper table word-break">
                    <h4 class="item-view-heading">
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
                    </h4>

                    <xsl:variable name="label-1">
                            <xsl:choose>
                                <xsl:when test="confman:getProperty('mirage2.item-view.bitstream.href.label.1')">
                                    <xsl:value-of select="confman:getProperty('mirage2.item-view.bitstream.href.label.1')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>label</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="label-2">
                            <xsl:choose>
                                <xsl:when test="confman:getProperty('mirage2.item-view.bitstream.href.label.2')">
                                    <xsl:value-of select="confman:getProperty('mirage2.item-view.bitstream.href.label.2')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>title</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                    </xsl:variable>

                    <xsl:for-each select="//mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
                        <xsl:call-template name="itemSummaryView-DIM-general-file-section-entry">
                            <xsl:with-param name="href" select="mets:FLocat[@LOCTYPE='URL']/@xlink:href" />
                            <xsl:with-param name="mimetype" select="@MIMETYPE" />
                            <xsl:with-param name="label-1" select="$label-1" />
                            <xsl:with-param name="label-2" select="$label-2" />
                            <xsl:with-param name="title" select="mets:FLocat[@LOCTYPE='URL']/@xlink:title" />
                            <xsl:with-param name="label" select="mets:FLocat[@LOCTYPE='URL']/@xlink:label" />
                            <xsl:with-param name="size" select="@SIZE" />
                        </xsl:call-template>
                    </xsl:for-each>
                </div>
            </xsl:when>
            <!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
            <xsl:when test="//mets:fileSec/mets:fileGrp[@USE='ORE']">
                <xsl:apply-templates select="//mets:fileSec/mets:fileGrp[@USE='ORE']" mode="itemSummaryView-DIM" />
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-general-URI">
        <xsl:if test="dim:field[@element='identifier' and @qualifier='uri' and descendant::text()]">
            <div class="simple-item-view-uri item-page-field-wrapper table">
                <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text></h4>
                <span>
                    <xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:copy-of select="./node()"/>
                            </xsl:attribute>
                            <xsl:copy-of select="./node()"/>
                        </a>
                        <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </span>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-general-collections">
    <!-- TODO: Create hierarchy of DSpace Community, Subcommunities and Collection and display it in some comprehensive manner-->
        <xsl:if test="$document//dri:referenceSet[@id='aspect.artifactbrowser.ItemViewer.referenceSet.collection-viewer']">
            <div class="simple-item-view-collections item-page-field-wrapper table">
                <h4 class="item-view-heading">
                    <i18n:text>xmlui.mirage2.itemSummaryView.Collections</i18n:text>
                </h4>
                <xsl:apply-templates select="$document//dri:referenceSet[@id='aspect.artifactbrowser.ItemViewer.referenceSet.collection-viewer']/dri:reference"/>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-general-file-section-entry">
        <xsl:param name="href" />
        <xsl:param name="mimetype" />
        <xsl:param name="label-1" />
        <xsl:param name="label-2" />
        <xsl:param name="title" />
        <xsl:param name="label" />
        <xsl:param name="size" />
        <div>
            <h5 class="item-list-entry">
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="$href"/>
                </xsl:attribute>
                <xsl:call-template name="getFileIcon">
                    <xsl:with-param name="mimetype">
                        <xsl:value-of select="substring-before($mimetype,'/')"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="substring-after($mimetype,'/')"/>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="contains($label-1, 'label') and string-length($label)!=0">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:when test="contains($label-1, 'title') and string-length($title)!=0">
                        <xsl:value-of select="$title"/>
                    </xsl:when>
                    <xsl:when test="contains($label-2, 'label') and string-length($label)!=0">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:when test="contains($label-2, 'title') and string-length($title)!=0">
                        <xsl:value-of select="$title"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getFileTypeDesc">
                            <xsl:with-param name="mimetype">
                                <xsl:value-of select="substring-before($mimetype,'/')"/>
                                <xsl:text>/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="contains($mimetype,';')">
                                        <xsl:value-of select="substring-before(substring-after($mimetype,'/'),';')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-after($mimetype,'/')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> (</xsl:text>
                <xsl:choose>
                    <xsl:when test="$size &lt; 1024">
                        <xsl:value-of select="$size"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="$size &lt; 1024 * 1024">
                        <xsl:value-of select="substring(string($size div 1024),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="$size &lt; 1024 * 1024 * 1024">
                        <xsl:value-of select="substring(string($size div (1024 * 1024)),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(string($size div (1024 * 1024 * 1024)),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>)</xsl:text>
            </a>
            </h5>
        </div>
    </xsl:template>

</xsl:stylesheet>