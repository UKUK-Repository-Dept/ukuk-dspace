<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->

<xsl:stylesheet
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:dri="http://di.tamu.edu/DRI/1.0/"
        xmlns:mets="http://www.loc.gov/METS/"
        xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
        xmlns:xlink="http://www.w3.org/TR/xlink/"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:xalan="http://xml.apache.org/xalan"
        xmlns:encoder="xalan://java.net.URLEncoder"
        xmlns:stringescapeutils="org.apache.commons.lang3.StringEscapeUtils"
        xmlns:util="org.dspace.app.xmlui.utils.XSLUtils" xmlns:xls="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="xalan encoder i18n dri mets dim  xlink xsl util stringescapeutils">

    <xsl:output indent="yes"/>

<!--
    These templates are devoted to rendering the search results for discovery.
    Since discovery used hit highlighting seperate templates are required !
-->


    <xsl:template match="dri:list[@type='dsolist']" priority="2">
        <xsl:apply-templates select="dri:head"/>
        <xsl:apply-templates select="*[not(name()='head')]" mode="dsoList"/>
    </xsl:template>

    <xsl:template match="dri:list/dri:list" mode="dsoList" priority="7">
        <xsl:apply-templates select="dri:head"/>
        <xsl:apply-templates select="*[not(name()='head')]" mode="dsoList"/>
    </xsl:template>

    <xsl:template match="dri:list/dri:list/dri:list" mode="dsoList" priority="8">
            <!--
                Retrieve the type from our name, the name contains the following format:
                    {handle}:{metadata}
            -->
            <xsl:variable name="handle">
                <xsl:value-of select="substring-before(@n, ':')"/>
            </xsl:variable>
            <xsl:variable name="type">
                <xsl:value-of select="substring-after(@n, ':')"/>
            </xsl:variable>
            <xsl:variable name="externalMetadataURL">
                <xsl:text>cocoon://metadata/handle/</xsl:text>
                <xsl:value-of select="$handle"/>
                <xsl:text>/mets.xml</xsl:text>
                <!-- Since this is a summary only grab the descriptive metadata, and the thumbnails -->
                <xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=THUMBNAIL</xsl:text>
                <!-- An example of requesting a specific metadata standard (MODS and QDC crosswalks only work for items)->
                <xsl:if test="@type='DSpace Item'">
                    <xsl:text>&amp;dmdTypes=DC</xsl:text>
                </xsl:if>-->
            </xsl:variable>


        <xsl:choose>
            <xsl:when test="$type='community'">
                <xsl:call-template name="communitySummaryList">
                    <xsl:with-param name="handle">
                        <xsl:value-of select="$handle"/>
                    </xsl:with-param>
                    <xsl:with-param name="externalMetadataUrl">
                        <xsl:value-of select="$externalMetadataURL"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$type='collection'">
                <xsl:call-template name="collectionSummaryList">
                    <xsl:with-param name="handle">
                        <xsl:value-of select="$handle"/>
                    </xsl:with-param>
                    <xsl:with-param name="externalMetadataUrl">
                        <xsl:value-of select="$externalMetadataURL"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$type='item'">
                <xsl:call-template name="itemSummaryList">
                    <xsl:with-param name="handle">
                        <xsl:value-of select="$handle"/>
                    </xsl:with-param>
                    <xsl:with-param name="externalMetadataUrl">
                        <xsl:value-of select="$externalMetadataURL"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="communitySummaryList">
        <xsl:param name="handle"/>
        <xsl:param name="externalMetadataUrl"/>

        <xsl:variable name="metsDoc" select="document($externalMetadataUrl)"/>

        <div class="community-browser-row">
            <a href="{$metsDoc/mets:METS/@OBJID}">
                <xsl:choose>
                    <xsl:when test="dri:list[@n=(concat($handle, ':dc.title')) and descendant::text()]">
                        <xsl:apply-templates select="dri:list[@n=(concat($handle, ':dc.title'))]/dri:item"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
                <!--Display community strengths (item counts) if they exist-->
                <xsl:if test="string-length($metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='format'][@qualifier='extent'][1]) &gt; 0">
                    <xsl:text> [</xsl:text>
                    <xsl:value-of
                            select="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='format'][@qualifier='extent'][1]"/>
                    <xsl:text>]</xsl:text>
                </xsl:if>
            </a>
            <div class="artifact-info">
            <xsl:if test="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item">
                <p>
                    <xsl:apply-templates select="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item[1]"/>
                </p>
            </xsl:if>
        </div>

        </div>
    </xsl:template>

    <xsl:template name="collectionSummaryList">
        <xsl:param name="handle"/>
        <xsl:param name="externalMetadataUrl"/>

        <xsl:call-template name="communitySummaryList">
            <xsl:with-param name="handle">
                <xsl:value-of select="$handle"/>
            </xsl:with-param>
            <xsl:with-param name="externalMetadataUrl">
                <xsl:value-of select="$externalMetadataUrl"/>
            </xsl:with-param>
        </xsl:call-template>

    </xsl:template>
    <xsl:template name="itemSummaryList">
        <xsl:param name="handle"/>
        <xsl:param name="externalMetadataUrl"/>

        <xsl:variable name="metsDoc" select="document($externalMetadataUrl)"/>

        <div class="row ds-artifact-item search-result-item-div">
            <!--Generates thumbnails (if present)-->
            <div class="col-sm-3 hidden-xs">
                <xsl:apply-templates select="$metsDoc/mets:METS/mets:fileSec" mode="artifact-preview">
                    <xsl:with-param name="href" select="concat($context-path, '/handle/', $handle)"/>
                </xsl:apply-templates>
            </div>

            <div class="col-sm-9 artifact-description">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/@withdrawn">
                                <xsl:value-of select="$metsDoc/mets:METS/@OBJEDIT"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($context-path, '/handle/', $handle)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <h4>
                        <xsl:choose>
                            <xsl:when test="dri:list[@n=(concat($handle, ':dc.title'))]">
                                <xsl:apply-templates select="dri:list[@n=(concat($handle, ':dc.title'))]/dri:item"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- Generate COinS with empty content per spec but force Cocoon to not create a minified tag  -->
                        <span class="Z3988" aria-hidden="true">
                            <xsl:attribute name="title">
                                <xsl:for-each select="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim">
                                    <xsl:call-template name="renderCOinS"/>
                                </xsl:for-each>
                            </xsl:attribute>
                            <xsl:text>&#160;</xsl:text>
                            <!-- non-breaking space to force separating the end tag -->
                        </span>
                    </h4>
                </xsl:element>
                
                <!-- <JR> - 3. 3. 2020 - Translated titles -->
                <xsl:choose>
                    <xsl:when test="count($metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='title'][@qualifier='translated']) > 1">
                        <xsl:for-each select="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='title'][@qualifier='translated']">
                            <h5 class="heading-translated">
                                <xsl:value-of select="./node()"/>
                            </h5>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <h5 class="heading-translated">
                                <xsl:value-of select="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='title'][@qualifier='translated']"/>
                        </h5>
                    </xsl:otherwise>
                </xsl:choose>
                
                <h5 class="work-type">
                    <xsl:choose>
                        <xsl:when test="dri:list[@n=(concat($handle, ':dc.type'))]">
                            <!--<xsl:apply-templates select="dri:list[@n=(concat($handle, ':dc.type'))]/dri:item"/>-->
                            <!--<xsl:text> / </xsl:text>-->
                            <xsl:call-template name="translateWorkType">
                                <xsl:with-param name="workType" select="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='type']"/>
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                    <!-- <JR> - 14. 10. 2020 - Added defence status to discovery item-list  -->
                    <xsl:if test="dim:field[@element='grade' and @qualifier='cs']">
                        <xsl:if test="dim:field[@element='grade' and @qualifier='cs']">
                            <xsl:choose>
                                <xsl:when test="node()/text()='Výtečně'">
                                    <xsl:text> (</xsl:text>
                                        <span class="text-theses-defended"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text></span>
                                    <xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:when test="node()/text()='Výborně'">
                                    <xsl:text> (</xsl:text>
                                        <span class="text-theses-defended"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text></span>
                                    <xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:when test="node()/text()='Velmi dobře'">
                                    <xsl:text> (</xsl:text>
                                        <span class="text-theses-defended"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text></span>
                                    <xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:when test="node()/text()='Dobře'">
                                    <xsl:text> (</xsl:text>
                                        <span class="text-theses-defended"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text></span>
                                    <xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:when test="node()/text()='Prospěl'">
                                    <xsl:text> (</xsl:text>
                                        <span class="text-theses-defended"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text></span>
                                    <xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:when test="node()/text()='Prospěl/a'">
                                    <xsl:text> (</xsl:text>
                                        <span class="text-theses-defended"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text></span>
                                    <xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:when test="node()/text()='Uspokojivě'">
                                    <xsl:text> (</xsl:text>
                                        <span class="text-theses-defended"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text></span>
                                    <xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:when test="node()/text()='Dostatečně'">
                                    <xsl:text> (</xsl:text>
                                        <span class="text-theses-defended"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text></span>
                                    <xsl:text>)</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text> (</xsl:text>
                                        <span class="text-theses-failed"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-not-defended-item-view</i18n:text></span>
                                    <xsl:text>)</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:if>
                </h5>
                <div class="artifact-info artifact-info-author">
                    <span class="author h4">
                        <small>
                            <xsl:element name="b">
                                <xsl:attribute name="class">
                                    <xsl:text>search-result-metadata-heading</xsl:text>
                                </xsl:attribute>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text><xsl:text>: </xsl:text>
                            </xsl:element>
                            <xsl:choose>
                                <xsl:when test="dri:list[@n=(concat($handle, ':dc.contributor.author'))]">
                                    <xsl:for-each select="dri:list[@n=(concat($handle, ':dc.contributor.author'))]/dri:item">
                                        <xsl:variable name="author">
                                            <xsl:apply-templates select="."/>
                                        </xsl:variable>
                                        <span>
                                            <!--Check authority in the mets document-->
                                            <xsl:if test="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='contributor' and @qualifier='author' and . = $author]/@authority">
                                                <xsl:attribute name="class">
                                                    <xsl:text>ds-dc_contributor_author-authority</xsl:text>
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:apply-templates select="."/>
                                        </span>

                                        <xsl:if test="count(following-sibling::dri:item) != 0">
                                            <xsl:text>; </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="dri:list[@n=(concat($handle, ':dc.creator'))]">
                                    <xsl:for-each select="dri:list[@n=(concat($handle, ':dc.creator'))]/dri:item">
                                        <xsl:apply-templates select="."/>
                                        <xsl:if test="count(following-sibling::dri:item) != 0">
                                            <xsl:text>; </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="dri:list[@n=(concat($handle, ':dc.contributor'))]">
                                    <xsl:for-each select="dri:list[@n=(concat($handle, ':dc.contributor'))]/dri:item">
                                        <xsl:apply-templates select="."/>
                                        <xsl:if test="count(following-sibling::dri:item) != 0">
                                            <xsl:text>; </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </small>
                    </span>
                    <xsl:text> </xsl:text>
                </div>
                <xsl:if test="dri:list[@n=(concat($handle, ':dc.contributor.advisor'))]">
                    <div class="artifact-info artifact-info-advisor">
                        <span class="advisor h4">
                            <small>
                                <xsl:element name="b">
                                    <xsl:attribute name="class">
                                        <xsl:text>search-result-metadata-heading</xsl:text>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.METS-1.0.item-advisor-item-view</i18n:text><xsl:text>: </xsl:text>
                                </xsl:element>
                                <xsl:choose>
                                    <xsl:when test="dri:list[@n=(concat($handle, ':dc.contributor.advisor'))]">
                                        <xsl:for-each select="dri:list[@n=(concat($handle, ':dc.contributor.advisor'))]/dri:item">
                                            <xsl:variable name="advisor">
                                                <xsl:apply-templates select="."/>
                                            </xsl:variable>
                                            <span>
                                                <!--Check authority in the mets document-->
                                                <xsl:if test="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='contributor' and @qualifier='advisor' and . = $advisor]/@authority">
                                                    <xsl:attribute name="class">
                                                        <xsl:text>ds-dc_contributor_author-authority</xsl:text>
                                                    </xsl:attribute>
                                                </xsl:if>
                                                <xsl:apply-templates select="."/>
                                            </span>

                                            <xsl:if test="count(following-sibling::dri:item) != 0">
                                                <xsl:text>; </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                </xsl:choose>
                            </small>
                        </span>
                        <xsl:text> </xsl:text>
                    </div>
                </xsl:if>
                <xsl:if test="dri:list[@n=(concat($handle, ':dc.date.issued'))]">
                    <div class="artifact-info artifact-info-dateIssued">
                        <span class="date-issued h4">
                            <small>
                                <xsl:element name="b">
                                    <xsl:attribute name="class">
                                        <xsl:text>search-result-metadata-heading</xsl:text>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.Submission.submit.InitialQuestionsStep.date_issued</i18n:text><xsl:text>: </xsl:text>
                                </xsl:element>
                                <xsl:choose>
                                    <xsl:when test="dri:list[@n=(concat($handle, ':dc.date.issued'))]">
                                        <!--select="substring(dri:list[@n=(concat($handle, ':dc.date.issued'))]/dri:item,1,10)"/>-->
                                        <xsl:for-each select="dri:list[@n=(concat($handle, ':dc.date.issued'))]/dri:item">
                                            <!-- <xsl:variable name="dateIssued"> -->
                                                <xsl:call-template name="formatdate">
                                                    <xsl:with-param name="date" select="."/>
                                                </xsl:call-template>
                                                <!-- <xsl:apply-templates select="."/> -->
                                            <!-- </xsl:variable> -->
                                            <xsl:if test="count(following-sibling::dri:item) != 0">
                                                <xsl:text>; </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                </xsl:choose>
                            </small>
                        </span>
                        <xsl:text> </xsl:text>
                    </div>
                </xsl:if>
                <xsl:if test="dri:list[@n=(concat($handle, ':dcterms.dateAccepted'))]">
                    <div class="artifact-info artifact-info-defenseDate">
                        <span class="date-issued h4">
                            <small>
                                <xsl:element name="b">
                                    <xsl:attribute name="class">
                                        <xsl:text>search-result-metadata-heading</xsl:text>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.METS-1.0.item-acceptance-date-item-view</i18n:text><xsl:text>: </xsl:text>
                                </xsl:element>
                                <xsl:choose>
                                    <xsl:when test="dri:list[@n=(concat($handle, ':dcterms.dateAccepted'))]">
                                        <xsl:for-each select="dri:list[@n=(concat($handle, ':dcterms.dateAccepted'))]/dri:item">
                                            <!--<xsl:variable name="dateAccepted">-->
                                            <xsl:call-template name="formatdate">
                                                <xsl:with-param name="date" select="."/>
                                            </xsl:call-template>
                                            <!--<xsl:apply-templates select="."/>-->
                                                <!--<xsl:apply-templates select="formatdate"/>-->
                                            <!--</xsl:variable>-->
                                            <xsl:if test="count(following-sibling::dri:item) != 0">
                                                <xsl:text>; </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                </xsl:choose>
                            </small>
                        </span>
                        <xsl:text> </xsl:text>
                    </div>
                </xsl:if>
                <xsl:if test="dri:list[@n=(concat($handle, ':uk.faculty-name.cs'))]">
                    <div class="artifact-info artifact-info-faculty">
                        <span class="faculty h4">
                            <small>
                                <xsl:element name="b">
                                    <xsl:attribute name="class">
                                        <xsl:text>search-result-metadata-heading</xsl:text>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.METS-1.0.item-faculty-item-view</i18n:text><xsl:text>: </xsl:text>
                                </xsl:element>
                                <xsl:for-each select="dri:list[@n=(concat($handle, ':uk.faculty-name.cs'))]/dri:item">
                                    <xsl:apply-templates select="."/>
                                </xsl:for-each>
                                <xsl:if test="dri:list[@n=(concat($handle, ':uk.faculty-name.en'))]">
                                    <xsl:text> / </xsl:text>
                                    <xsl:for-each select="dri:list[@n=(concat($handle, ':uk.faculty-name.en'))]/dri:item">
                                        <xsl:apply-templates select="."/>
                                    </xsl:for-each>
                                </xsl:if>
                            </small>
                        </span>
                        <xsl:text> </xsl:text>
                    </div>
                </xsl:if>
                <!-- <JR> - 14. 10. 2020 - Adding embargo information to thesis discovery results -->
                <xsl:if test="dri:list[@n=(concat($handle, ':dc.date.embargoEndDate'))]">
                    <div class="artifact-info artifact-info-embargo">
                        <span class="embargo-information h4">
                            <small>
                                <xsl:element name="b">
                                    <xsl:attribute name="class">
                                        <xsl:text>search-result-metadata-heading</xsl:text>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.METS-1.0.item-embargo-date-text</i18n:text><xsl:text>: </xsl:text>
                                </xsl:element>
                                <xsl:for-each select="dri:list[@n=(concat($handle, ':dc.date.embargoEndDate'))]/dri:item">
                                    <xsl:variable name="embargo-date" select="dri:list[@n=(concat($handle, ':dc.date.embargoEndDate'))]/dri:item/text()" />
                                    <xsl:value-of select="dri:list[@n=(concat($handle, ':dc.date.embargoEndDate'))]/dri:item" />
                                    <xsl:call-template name="formatdate-SIS">
                                        <xsl:with-param name="DateTimeStr" select="$embargo-date" />
                                    </xsl:call-template>
                                </xsl:for-each>
                            </small>
                        </span>
                    </div>
                    <!-- <xsl:variable name="embargo-date" select="dim:field[@element='date' and @qualifier='embargoEndDate']/text()" />
            
                    <xsl:variable name="embargo-date-formated">
                        <xsl:call-template name="formatdate-SIS">
                            <xsl:with-param name="DateTimeStr" select="$embargo-date" />
                        </xsl:call-template>
                    </xsl:variable>

                    <span class="embargo-information h4">
                        <small>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-embargo-date-text</i18n:text><xsl:text> </xsl:text><xsl:value-of select="$embargo-date-formated" />
                        </small>
                    </span> -->
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item/dri:hi">
                        <!--
                            search term found in abstract - show context
                            around search term location(s)
                        -->
                        <div class="abstract">
                            <span class="abstract h4">
                                <small>
                                    <xsl:element name="b">
                                        <xsl:attribute name="class">
                                            <xsl:text>search-result-metadata-heading</xsl:text>
                                        </xsl:attribute>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-discovery-found-in-abstract</i18n:text><xsl:text>: </xsl:text>
                                    </xsl:element>

                                    <xsl:for-each select="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item">
                                        <xsl:text>… </xsl:text><xsl:apply-templates select="."/><xsl:text> …</xsl:text>
                                        <br/>
                                        <br/>
                                    </xsl:for-each>
                                    <!--<xsl:if test="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item/dri:hi">-->
                                        <!--<xsl:text>… </xsl:text><xsl:apply-templates select="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item[1]"/><xsl:text> …</xsl:text>-->
                                    <!--</xsl:if>-->
                                    <!--<xsl:text>… </xsl:text><xsl:apply-templates select="."/><xsl:text> …</xsl:text>-->
                                    <!--<xsl:value-of select="util:shortenString(dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item, 220, 10)"/>-->
                                </small>
                            </span>
                        </div>
                    </xsl:when>
                    <xsl:when test="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item">
                        <!--
                             search term not found in abstract but the item has an abstract
                             - show first part of abstract like in recently added lists
                        -->
                        <div class="abstract">
                            <span class="abstract h4">
                                <small>
                                    <xsl:element name="b">
                                        <xsl:attribute name="class">
                                            <xsl:text>search-result-metadata-heading</xsl:text>
                                        </xsl:attribute>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text><xsl:text>: </xsl:text>
                                    </xsl:element>

                                    <xsl:for-each select="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item">
                                        <xsl:value-of select="util:shortenString(., 220, 10)"/>
                                        <!--<xsl:text>… </xsl:text><xsl:apply-templates select="."/><xsl:text> …</xsl:text>-->
                                        <br/>
                                        <br/>
                                    </xsl:for-each>
                                </small>
                            </span>

                        </div>
                    </xsl:when>
                    <xsl:when test="not(dri:list[@n=(concat($handle, 'dc.description.abstract'))]/dri:item)">
                        <div class="abstract">
                            <span class="abstract h4">
                                <small>
                                    <xsl:element name="b">
                                        <xsl:attribute name="class">
                                            <xsl:text>search-result-metadata-heading</xsl:text>
                                        </xsl:attribute>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-discovery-abstract-not-found</i18n:text>
                                    </xsl:element>

                                    <!--<xsl:for-each select="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item">-->
                                        <!--<xsl:text>… </xsl:text><xsl:apply-templates select="."/><xsl:text> …</xsl:text>-->
                                        <!--<br/>-->
                                    <!--</xsl:for-each>-->
                                </small>
                            </span>
                        </div>
                    </xsl:when>
                    <!--<xsl:otherwise>-->
                        <!---->
                    <!--</xsl:otherwise>-->
                </xsl:choose>
                <xsl:if test="not(dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item/dri:hi) and dri:list[@n=(concat($handle, ':fulltext'))]">
                            <!--
                              search term not found in abstract but found in fulltext file -
                              show message _instead_ of preview; if there is an abstract
                              then it will already be shown via the choose statement above
                            -->
                            <div class="abstract">
                                <!--<xsl:for-each select="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item">-->
                                <span class="h4">
                                    <small>
                                        <xsl:element name="b">
                                            <xsl:attribute name="class">
                                                <xsl:text>search-result-metadata-heading</xsl:text>
                                            </xsl:attribute>
                                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-discovery-found-in-fulltext</i18n:text>
                                        </xsl:element>
                                    </small>
                                </span>
                                <!--<br/>-->
                                <!--</xsl:for-each>-->
                            </div>
                            <!--<strong>(Search term found in fulltext file)</strong>-->
                    </xsl:if>
                <!--<xsl:if test="not(dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item/dri:hi) and dri:list[@n=(concat($handle, ':fulltext'))]">-->
                  <!--&lt;!&ndash;-->
                      <!--search term not found in abstract but found in fulltext file - -->
                      <!--show message _instead_ of preview; if there is an abstract-->
                      <!--then it will already be shown via the choose statement above-->
                  <!--&ndash;&gt;-->
                  <!--<strong>(Search term found in fulltext file)</strong>-->
                <!--</xsl:if>-->
            </div>
        </div>

    </xsl:template>

    <xsl:template name="translateWorkType">
        <xsl:param name="workType" />

        <xsl:variable name="wt">
            <xsl:value-of select="$workType" />
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$wt = 'bakalářská práce'">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-bachelor-th-item-view</i18n:text>
            </xsl:when>
            <xsl:when test="$wt = 'diplomová práce'">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-diploma-th-item-view</i18n:text>
            </xsl:when>
            <xsl:when test="$wt = 'rigorózní práce'">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-rigo-th-item-view</i18n:text>
            </xsl:when>
            <xsl:when test="$wt = 'dizertační práce'">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-disert-th-item-view</i18n:text>
            </xsl:when>
            <xsl:when test="$wt = 'habilitační práce'">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-habi-th-item-view</i18n:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$wt"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="formatdate">
        <xsl:param name="date" />

        <xsl:variable name="datestr">
            <xsl:value-of select="$date" />
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="string-length($datestr) = 4">
                <xsl:value-of select="$datestr"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="mm">
                    <xsl:value-of select="substring($datestr,6,2)" />
                </xsl:variable>

                <xsl:variable name="dd">
                    <xsl:value-of select="substring($datestr,9,2)" />
                </xsl:variable>

                <xsl:variable name="yyyy">
                    <xsl:value-of select="substring($datestr,1,4)" />
                </xsl:variable>

                <xsl:value-of select="concat($dd,'. ', $mm, '. ', $yyyy)" />
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

    <!--<xsl:template name="itemSummaryList">-->
        <!--<xsl:param name="handle"/>-->
        <!--<xsl:param name="externalMetadataUrl"/>-->

        <!--<xsl:variable name="metsDoc" select="document($externalMetadataUrl)"/>-->

        <!--<div class="row ds-artifact-item ">-->

            <!--&lt;!&ndash;Generates thumbnails (if present)&ndash;&gt;-->
            <!--<div class="col-sm-3 hidden-xs">-->
                <!--<xsl:apply-templates select="$metsDoc/mets:METS/mets:fileSec" mode="artifact-preview">-->
                    <!--<xsl:with-param name="href" select="concat($context-path, '/handle/', $handle)"/>-->
                <!--</xsl:apply-templates>-->
            <!--</div>-->


            <!--<div class="col-sm-9 artifact-description">-->
                <!--<xsl:element name="a">-->
                    <!--<xsl:attribute name="href">-->
                        <!--<xsl:choose>-->
                            <!--<xsl:when test="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/@withdrawn">-->
                                <!--<xsl:value-of select="$metsDoc/mets:METS/@OBJEDIT"/>-->
                            <!--</xsl:when>-->
                            <!--<xsl:otherwise>-->
                                <!--<xsl:value-of select="concat($context-path, '/handle/', $handle)"/>-->
                            <!--</xsl:otherwise>-->
                        <!--</xsl:choose>-->
                    <!--</xsl:attribute>-->
                    <!--<h4>-->
                        <!--<xsl:choose>-->
                            <!--<xsl:when test="dri:list[@n=(concat($handle, ':dc.title'))]">-->
                                <!--<xsl:apply-templates select="dri:list[@n=(concat($handle, ':dc.title'))]/dri:item"/>-->
                            <!--</xsl:when>-->
                            <!--<xsl:otherwise>-->
                                <!--<i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>-->
                            <!--</xsl:otherwise>-->
                        <!--</xsl:choose>-->
                        <!--&lt;!&ndash; Generate COinS with empty content per spec but force Cocoon to not create a minified tag  &ndash;&gt;-->
                        <!--<span class="Z3988">-->
                            <!--<xsl:attribute name="title">-->
                                <!--<xsl:for-each select="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim">-->
                                    <!--<xsl:call-template name="renderCOinS"/>-->
                                <!--</xsl:for-each>-->
                            <!--</xsl:attribute>-->
                            <!--<xsl:text>&#160;</xsl:text>-->
                            <!--&lt;!&ndash; non-breaking space to force separating the end tag &ndash;&gt;-->
                        <!--</span>-->
                    <!--</h4>-->
                <!--</xsl:element>-->
                <!--<div class="artifact-info">-->
                    <!--<span class="author h4">    <small>-->
                        <!--<xsl:choose>-->
                            <!--<xsl:when test="dri:list[@n=(concat($handle, ':dc.contributor.author'))]">-->
                                <!--<xsl:for-each select="dri:list[@n=(concat($handle, ':dc.contributor.author'))]/dri:item">-->
                                    <!--<xsl:variable name="author">-->
                                        <!--<xsl:apply-templates select="."/>-->
                                    <!--</xsl:variable>-->
                                    <!--<span>-->
                                        <!--&lt;!&ndash;Check authority in the mets document&ndash;&gt;-->
                                        <!--<xsl:if test="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='contributor' and @qualifier='author' and . = $author]/@authority">-->
                                            <!--<xsl:attribute name="class">-->
                                                <!--<xsl:text>ds-dc_contributor_author-authority</xsl:text>-->
                                            <!--</xsl:attribute>-->
                                        <!--</xsl:if>-->
                                        <!--<xsl:apply-templates select="."/>-->
                                    <!--</span>-->

                                    <!--<xsl:if test="count(following-sibling::dri:item) != 0">-->
                                        <!--<xsl:text>; </xsl:text>-->
                                    <!--</xsl:if>-->
                                <!--</xsl:for-each>-->
                            <!--</xsl:when>-->
                            <!--<xsl:when test="dri:list[@n=(concat($handle, ':dc.creator'))]">-->
                                <!--<xsl:for-each select="dri:list[@n=(concat($handle, ':dc.creator'))]/dri:item">-->
                                    <!--<xsl:apply-templates select="."/>-->
                                    <!--<xsl:if test="count(following-sibling::dri:item) != 0">-->
                                        <!--<xsl:text>; </xsl:text>-->
                                    <!--</xsl:if>-->
                                <!--</xsl:for-each>-->
                            <!--</xsl:when>-->
                            <!--<xsl:when test="dri:list[@n=(concat($handle, ':dc.contributor'))]">-->
                                <!--<xsl:for-each select="dri:list[@n=(concat($handle, ':dc.contributor'))]/dri:item">-->
                                    <!--<xsl:apply-templates select="."/>-->
                                    <!--<xsl:if test="count(following-sibling::dri:item) != 0">-->
                                        <!--<xsl:text>; </xsl:text>-->
                                    <!--</xsl:if>-->
                                <!--</xsl:for-each>-->
                            <!--</xsl:when>-->
                            <!--<xsl:otherwise>-->
                                <!--<i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>-->
                            <!--</xsl:otherwise>-->
                        <!--</xsl:choose>-->
                        <!--</small></span>-->
                    <!--<xsl:text> </xsl:text>-->
                    <!--<xsl:if test="dri:list[@n=(concat($handle, ':dc.date.issued'))]">-->
                        <!--<span class="publisher-date h4">   <small>-->
                            <!--<xsl:text>(</xsl:text>-->
                            <!--<xsl:if test="dri:list[@n=(concat($handle, ':dc.publisher'))]">-->
                                <!--<span class="publisher">-->
                                    <!--<xsl:apply-templates select="dri:list[@n=(concat($handle, ':dc.publisher'))]/dri:item"/>-->
                                <!--</span>-->
                                <!--<xsl:text>, </xsl:text>-->
                            <!--</xsl:if>-->
                            <!--<span class="date">-->
                                <!--<xsl:value-of-->
                                        <!--select="substring(dri:list[@n=(concat($handle, ':dc.date.issued'))]/dri:item,1,10)"/>-->
                            <!--</span>-->
                            <!--<xsl:text>)</xsl:text>-->
                            <!--</small></span>-->
                    <!--</xsl:if>-->
                    <!--<xsl:choose>-->
                        <!--<xsl:when test="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item/dri:hi">-->
                            <!--<div class="abstract">-->
                                <!--<xsl:for-each select="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item">-->
                                    <!--<xsl:apply-templates select="."/>-->
                                    <!--<xsl:text>...</xsl:text>-->
                                    <!--<br/>-->
                                <!--</xsl:for-each>-->

                            <!--</div>-->
                        <!--</xsl:when>-->
                        <!--<xsl:when test="dri:list[@n=(concat($handle, ':fulltext'))]">-->
                            <!--<div class="abstract">-->
                                <!--<xsl:for-each select="dri:list[@n=(concat($handle, ':fulltext'))]/dri:item">-->
                                    <!--<xsl:apply-templates select="."/>-->
                                    <!--<xsl:text>...</xsl:text>-->
                                    <!--<br/>-->
                                <!--</xsl:for-each>-->
                            <!--</div>-->
                        <!--</xsl:when>-->
                        <!--<xsl:when test="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item">-->
                        <!--<div class="abstract">-->
                                <!--<xsl:value-of select="util:shortenString(dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item[1], 220, 10)"/>-->
                        <!--</div>-->
                    <!--</xsl:when>-->
                    <!--</xsl:choose>-->
                <!--</div>-->
            <!--</div>-->
        <!--</div>-->
    <!--</xsl:template>-->

    <xsl:template match="dri:div[@id='aspect.discovery.SimpleSearch.div.discovery-filters-wrapper']/dri:head">
        <h3 class="ds-div-head discovery-filters-wrapper-head hidden">
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <xsl:template match="dri:list[@id='aspect.discovery.SimpleSearch.list.primary-search']" priority="3">
        <xsl:apply-templates select="dri:head"/>
        <fieldset>
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">
                    <!-- Provision for the sub list -->
                    <xsl:text>ds-form-</xsl:text>
                    <xsl:text>list </xsl:text>
                    <xsl:if test="count(dri:item) > 3">
                        <xsl:text>thick </xsl:text>
                    </xsl:if>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates select="*[not(name()='label' or name()='head')]" />
        </fieldset>
    </xsl:template>

    <xsl:template match="dri:list[@id='aspect.discovery.SimpleSearch.list.primary-search']//dri:item[dri:field[@id='aspect.discovery.SimpleSearch.field.query']]" priority="3">
        <div>
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">
                    <xsl:text>ds-form-item row</xsl:text>
                </xsl:with-param>
            </xsl:call-template>

            <div class="col-sm-3">
                <p>
                    <xsl:apply-templates select="dri:field[@id='aspect.discovery.SimpleSearch.field.scope']"/>
                </p>
            </div>

            <div class="col-sm-9">
                <p class="input-group">
                    <xsl:apply-templates select="dri:field[@id='aspect.discovery.SimpleSearch.field.query']"/>
                    <span class="input-group-btn">
                        <xsl:apply-templates select="dri:field[@id='aspect.discovery.SimpleSearch.field.submit']"/>
                    </span>
                </p>
            </div>
        </div>

        <xsl:if test="dri:item[@id='aspect.discovery.SimpleSearch.item.did-you-mean']">
            <div class="row">
                <div class="col-sm-offset-3 col-sm-9">
                    <xsl:apply-templates select="dri:item[@id='aspect.discovery.SimpleSearch.item.did-you-mean']"/>
                </div>
            </div>
        </xsl:if>

        <div class="row">
            <div class="col-sm-offset-3 col-sm-9" id="filters-overview-wrapper-squared"/>
        </div>
    </xsl:template>

    <xsl:template match="dri:list[@id='aspect.discovery.SimpleSearch.list.primary-search']//dri:item[dri:field[@id='aspect.discovery.SimpleSearch.field.query'] and not(dri:field[@id='aspect.discovery.SimpleSearch.field.scope'])]" priority="3">
        <div>
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">
                    <xsl:text>ds-form-item row</xsl:text>
                </xsl:with-param>
            </xsl:call-template>

            <div class="col-sm-12">
                <p class="input-group">
                    <xsl:apply-templates select="dri:field[@id='aspect.discovery.SimpleSearch.field.query']"/>
                    <span class="input-group-btn">
                        <xsl:apply-templates select="dri:field[@id='aspect.discovery.SimpleSearch.field.submit']"/>
                    </span>
                </p>
            </div>
        </div>
        <xsl:if test="dri:item[@id='aspect.discovery.SimpleSearch.item.did-you-mean']">
            <xsl:apply-templates select="dri:item[@id='aspect.discovery.SimpleSearch.item.did-you-mean']"/>
        </xsl:if>
        <div id="filters-overview-wrapper-squared"/>
    </xsl:template>

    <xsl:template match="dri:div[@id='aspect.discovery.SimpleSearch.div.search-results']/dri:head">
        <h4>
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class" select="@rend"/>
            </xsl:call-template>
            <xsl:apply-templates />
        </h4>
    </xsl:template>

    <xsl:template match="dri:table[@id='aspect.discovery.SimpleSearch.table.discovery-filters']">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="dri:table[@id='aspect.discovery.SimpleSearch.table.discovery-filters']/dri:row">
        <script type="text/javascript">
            <xsl:text>
                if (!window.DSpace) {
                    window.DSpace = {};
                }
                if (!window.DSpace.discovery) {
                    window.DSpace.discovery = {};
                }
                if (!window.DSpace.discovery.filters) {
                    window.DSpace.discovery.filters = [];
                }
                window.DSpace.discovery.filters.push({
                    type: '</xsl:text><xsl:value-of select="stringescapeutils:escapeEcmaScript(dri:cell/dri:field[starts-with(@n, 'filtertype')]/dri:value/@option)"/><xsl:text>',
                    relational_operator: '</xsl:text><xsl:value-of select="stringescapeutils:escapeEcmaScript(dri:cell/dri:field[starts-with(@n, 'filter_relational_operator')]/dri:value/@option)"/><xsl:text>',
                    query: '</xsl:text><xsl:value-of select="stringescapeutils:escapeEcmaScript(dri:cell/dri:field[@rend = 'discovery-filter-input']/dri:value)"/><xsl:text>',
                });
            </xsl:text>
        </script>
    </xsl:template>

    <xsl:template match="dri:row[starts-with(@id, 'aspect.discovery.SimpleSearch.row.filter-new-')]">
        <script type="text/javascript">
            <xsl:text>
                if (!window.DSpace) {
                    window.DSpace = {};
                }
                if (!window.DSpace.discovery) {
                    window.DSpace.discovery = {};
                }
                if (!window.DSpace.discovery.filters) {
                    window.DSpace.discovery.filters = [];
                }
            </xsl:text>
        </script>
        <script>
        <xsl:text>
            if (!window.DSpace.i18n) {
                window.DSpace.i18n = {};
            } 
            if (!window.DSpace.i18n.discovery) {
                window.DSpace.i18n.discovery = {};
            }
        </xsl:text>
            <xsl:for-each select="dri:cell/dri:field[@type='select']">
                <xsl:variable name="last_underscore_index">
                    <xsl:call-template name="lastCharIndex">
                        <xsl:with-param name="pText" select="@n"/>
                        <xsl:with-param name="pChar" select="'_'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="filter_name" select="substring(@n, 0, $last_underscore_index)"/>
                <xsl:text>
                    if (!window.DSpace.i18n.discovery.</xsl:text><xsl:value-of select="$filter_name"/><xsl:text>) {
                        window.DSpace.i18n.discovery.</xsl:text><xsl:value-of select="$filter_name"/><xsl:text> = {};
                    }
                </xsl:text>
                <xsl:for-each select="dri:option">
                    <xsl:text>window.DSpace.i18n.discovery.</xsl:text><xsl:value-of select="$filter_name"/>
                    <xsl:text>.</xsl:text><xsl:value-of select="@returnValue"/><xsl:text>='</xsl:text><xsl:copy-of select="./*"/><xsl:text>';</xsl:text>
                </xsl:for-each>
            </xsl:for-each>
        </script>
    </xsl:template>

    <xsl:template match="dri:row[@id='aspect.discovery.SimpleSearch.row.filter-controls']">
        <div>
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">
                    <xsl:text>ds-form-item</xsl:text>
                </xsl:with-param>
            </xsl:call-template>

            <div>
                    <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="dri:field[starts-with(@id, 'aspect.discovery.SimpleSearch.field.add-filter')]">
        <button>
            <xsl:call-template name="fieldAttributes"/>
            <xsl:attribute name="type">submit</xsl:attribute>
            <xsl:choose>
                <xsl:when test="dri:value/i18n:text">
                    <xsl:attribute name="title">
                        <xsl:apply-templates select="dri:value/*"/>
                    </xsl:attribute>
                    <xsl:attribute name="i18n:attr">
                        <xsl:text>title</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="title">
                        <xsl:value-of select="dri:value"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <span class="glyphicon glyphicon-plus-sign" aria-hidden="true"/>
        </button>
    </xsl:template>

    <xsl:template match="dri:field[starts-with(@id, 'aspect.discovery.SimpleSearch.field.remove-filter')]">
        <button>
            <xsl:call-template name="fieldAttributes"/>
            <xsl:attribute name="type">submit</xsl:attribute>
            <xsl:choose>
                <xsl:when test="dri:value/i18n:text">
                    <xsl:attribute name="title">
                        <xsl:apply-templates select="dri:value/*"/>
                    </xsl:attribute>
                    <xsl:attribute name="i18n:attr">
                        <xsl:text>title</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="title">
                        <xsl:value-of select="dri:value"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <span class="glyphicon glyphicon-minus-sign" aria-hidden="true"/>
        </button>
    </xsl:template>

    <xsl:template name="lastCharIndex">
        <xsl:param name="pText"/>
        <xsl:param name="pChar" select="' '"/>

        <xsl:variable name="vRev">
            <xsl:call-template name="reverse">
                <xsl:with-param name="pStr" select="$pText"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="string-length($pText) - string-length(substring-before($vRev, $pChar))"/>
    </xsl:template>

    <xsl:template name="reverse">
        <xsl:param name="pStr"/>

        <xsl:variable name="vLength" select="string-length($pStr)"/>
        <xsl:choose>
            <xsl:when test="$vLength = 1">
                <xsl:value-of select="$pStr"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="vHalfLength" select="floor($vLength div 2)"/>
                <xsl:variable name="vrevHalf1">
                    <xsl:call-template name="reverse">
                        <xsl:with-param name="pStr"
                                        select="substring($pStr, 1, $vHalfLength)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="vrevHalf2">
                    <xsl:call-template name="reverse">
                        <xsl:with-param name="pStr"
                                        select="substring($pStr, $vHalfLength+1)"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="concat($vrevHalf2, $vrevHalf1)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="dri:div[@rend='controls-gear-wrapper' and @n='search-controls-gear']">
        <div class="btn-group sort-options-menu pull-right">
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">btn-group discovery-sort-options-menu pull-right</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="renderGearButton"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="dri:list[@rend='gear-selection' and @n='sort-options']">
        <ul class="dropdown-menu" role="menu">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="dri:list[@rend='gear-selection' and @n='sort-options']/dri:item">
        <xsl:if test="contains(@rend, 'dropdown-header') and position() > 1">
            <li class="divider"/>
        </xsl:if>
        <li>
            <xsl:call-template name="standardAttributes"/>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="dri:list[@rend='gear-selection' and @n='sort-options']/dri:item/dri:xref">
        <a href="{@target}" class="{@rend}">
            <span>
                <xsl:attribute name="class">
                    <xsl:text>glyphicon glyphicon-ok btn-xs</xsl:text>
                    <xsl:choose>
                        <xsl:when test="contains(../@rend, 'gear-option-selected')">
                            <xsl:text> active</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> invisible</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </span>
            <xsl:apply-templates/>
        </a>
    </xsl:template>


    <xsl:template
            match="dri:div[@n='masked-page-control'][dri:div/@n='search-controls-gear']">
        <xsl:variable name="other_content_besides_gear"
                      select="*[not(@rend='controls-gear-wrapper' and @n='search-controls-gear')]"/>
        <xsl:if test="$other_content_besides_gear">
            <div>
                <xsl:call-template name="standardAttributes"/>
                <xsl:apply-templates select="$other_content_besides_gear"/>
            </div>
        </xsl:if>

    </xsl:template>

    <xsl:template name="formatdate-SIS">
        <xsl:param name="DateTimeStr" />
        <xsl:variable name="datestr">
            <xsl:value-of select="$DateTimeStr" />
        </xsl:variable>

        <xsl:variable name="dd">
            <xsl:value-of select="substring($datestr,1,2)" />
        </xsl:variable>

        <xsl:variable name="mm">
            <xsl:value-of select="substring($datestr,4,2)" />
        </xsl:variable>

        <xsl:variable name="yyyy">
            <xsl:value-of select="substring($datestr,7,4)" />
        </xsl:variable>

        <xsl:value-of select="concat($dd,'. ', $mm, '. ', $yyyy)" />
    </xsl:template>


</xsl:stylesheet>
