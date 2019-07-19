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
        <xsl:choose>
            <xsl:when test="dim:field[@element='title'][@qualifier]">
                    <xsl:for-each select="dim:field[@element='title'][@qualifier]">
                        <!--<xsl:if test="not(position() = 1)">-->
                            <xsl:value-of select="./node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='title'][not(not(@qualifier))]) != 0">
                                <xsl:text> </xsl:text>
                                <br/>
                            </xsl:if>
                        <!--</xsl:if>-->
                    </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-general-title-translated">
        <xsl:if test="dim:field[@element='title' and @qualifier='translated']">
            <xsl:value-of select="dim:field[@element='title' and @qualifier='translated']"/>
        </xsl:if>
    </xsl:template>

    <!-- <JR> - 20. 2. 2017 -->
    <!-- DC.TYPE -->
    <xsl:template name="itemSummaryView-DIM-general-work-type">
        <xsl:choose>
            <xsl:when test="$active-locale='en'">
                <xsl:choose>
                    <xsl:when test="dim:field[@element='type' and @language='en_US']">
                        <xsl:value-of select="dim:field[@element='type' and @language='en_US']" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='type']='bakalářská práce'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-bachelor-th-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='type']='diplomová práce'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-diploma-th-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='type']='rigorózní práce'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-rigo-th-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='type']='dizertační práce'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-disert-th-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='type']='habilitační práce'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-habi-th-item-view</i18n:text>
                            </xsl:when>
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
                            <xsl:when test="dim:field[@element='type']='bakalářská práce'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-bachelor-th-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='type']='diplomová práce'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-diploma-th-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='type']='rigorózní práce'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-rigo-th-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='type']='dizertační práce'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-disert-th-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='type']='habilitační práce'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-type-habi-th-item-view</i18n:text>
                            </xsl:when>
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

    <!-- AUTHORS -->
    <xsl:template name="itemSummaryView-DIM-general-authors">
        <!--<xsl:if test="dim:field[@element='contributor'][@qualifier='author' and descendant::text()] or dim:field[@element='creator' and descendant::text()] or dim:field[@element='contributor' and descendant::text()]">-->

            <div class="simple-item-view-authors item-page-field-wrapper table">
                <xsl:choose>
                    <xsl:when test="count(dim:field[@element='contributor'][@qualifier='author']) &gt; 1">
                        <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author-multiple</i18n:text></h4>
                    </xsl:when>
                    <xsl:when test="count(dim:field[@element='creator']) &gt; 1">
                        <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author-multiple</i18n:text></h4>
                    </xsl:when>
                    <xsl:otherwise>
                        <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text></h4>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator']">
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                        </xsl:for-each>
                        <xsl:for-each select="dim:field[@element='creator']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        <!--</xsl:if>-->
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-authors-entry">
        <div>
            <xsl:if test="@authority">
                <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
            </xsl:if>
            <a>
                <xsl:attribute name="href">
                    <xsl:text>/browse?type=author&amp;value=</xsl:text><xsl:copy-of select="./node()"/>
                </xsl:attribute>
                <xsl:copy-of select="node()"/>
            </a>
        </div>
    </xsl:template>

    <!-- END OF AUTHORS -->

    <!-- CONTRIBUTORS -->
    <xsl:template name="itemSummaryView-DIM-general-contributors">
        <xsl:if test="count(dim:field[@element='contributor'][not(@qualifier='author')]) &gt; 0">
            <div class="simple-item-view-contributors item-page-field-wrapper table">
                <xsl:choose>
                    <xsl:when test="count(dim:field[@element='contributor'][not(@qualifier='author')]) &gt; 1">
                        <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-contributor-multiple</i18n:text></h4>
                    </xsl:when>
                    <xsl:otherwise>
                        <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-contributor</i18n:text></h4>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                        <xsl:when test="dim:field[@element='contributor'][not(@qualifier='author')]">
                            <xsl:for-each select="dim:field[@element='contributor'][not(@qualifier='author')]">
                                <xsl:call-template name="itemSummaryView-DIM-contributors-entry" />
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-contributors-entry">
        <div>
            <xsl:if test="@authority">
                <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
            </xsl:if>
            <a>
                <xsl:attribute name="href">
                    <xsl:text>/browse?type=author&amp;value=</xsl:text><xsl:copy-of select="./node()"/>
                </xsl:attribute>
                <xsl:copy-of select="node()"/>
            </a>
        </div>
    </xsl:template>
    <!-- END OF: CONTRIBUTORS -->

    <!-- <JR> - 22. 2. 2017 -->
    <xsl:template name="itemSummaryView-DIM-general-work-language">
        <div class="simple-item-view-description item-page-field-wrapper table">
            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-item-view</i18n:text></h4>
            <div>
                <xsl:choose>        
                    <xsl:when test="dim:field[@element='language' and @qualifier='iso']">
                    <!-- We have an dc.language.iso field available --> 
                        <xsl:choose>
                            <xsl:when test="node()/text()='cs_CZ'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-cs-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='en_US'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-en-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='de_DE'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-de-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='sk_SK'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-sk-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='fr_FR'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-fr-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='ru_RU'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-ru-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='it_IT'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-it-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='es_ES'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-es-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='pt_PT'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-pt-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='nl_NL'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-nl-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='pl_PL'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-pl-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='no_NO'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-no-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='sv_SE'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-sv-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='hu_HU'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-hu-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='sr_SP'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-sr-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='ro_RO'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-ro-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='lt_LT'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-lt-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='sh_RS'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-sh-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='da_DK'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-da-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='bg_BG'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-bg-item-view</i18n:text>
                            </xsl:when>
                                <xsl:when test="node()/text()='sl_SL'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-sl-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="node()/text()='uk_UA'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-uk-item-view</i18n:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-00-item-view</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='language'][not(@qualifier)]">
                    <!-- We have dc.langauge without qualifier available -->
                        <xsl:choose>
                           <xsl:when test="dim:field[@element='language']/text()='Čeština' or dim:field[@element='language']/text()='Czech'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-cs-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Angličtina' or dim:field[@element='language']/text()='English'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-en-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Němčina' or dim:field[@element='language']/text()='German'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-de-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Ruština' or dim:field[@element='language']/text()='Russian'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-ru-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Francouzština' or dim:field[@element='language']/text()='French'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-fr-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Španělština' or dim:field[@element='language']/text()='Spanish'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-es-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Portugalština' or dim:field[@element='language']/text()='Portuguese'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-pt-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Polština' or dim:field[@element='language']/text()='Polish'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-pl-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Norština' or dim:field[@element='language']/text()='Norwegian'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-no-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Švédština' or dim:field[@element='language']/text()='Swedish'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-sv-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Maďarština' or dim:field[@element='language']/text()='Hungarian'">
                                    <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-hu-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Srbština' or dim:field[@element='language']/text()='Serbian'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-sr-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Rumunština' or dim:field[@element='language']/text()='Romanian'">
                                    <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-ro-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Litevština' or dim:field[@element='language']/text()='Lithuanian'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-lt-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Srbochorvatština' or dim:field[@element='language']/text()='Serbo-Croatian'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-sh-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Dánština' or dim:field[@element='language']/text()='Danish'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-da-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Bulharština' or dim:field[@element='language']/text()='Bulgarian'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-bg-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Slovinština' or dim:field[@element='language']/text()='Slovenian'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-sl-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Ukrajinština' or dim:field[@element='language']/text()='Ukrainian'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-uk-item-view</i18n:text>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='language']/text()='Jiný' or dim:field[@element='language']/text()='Other'">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-00-item-view</i18n:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-work-language-00-item-view</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$active-locale='en'">
                                <xsl:text>Information unavailable</xsl:text>
                            </xsl:when>
                            <xsl:when test="$active-locale='cs'">
                                <xsl:text>Informace není k dispozici</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Information unavailable</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>
    </xsl:template>

    <!--    END OF: WORK language   -->

    <!-- KEYWORDS (GENERAL)-->

    <xsl:template name="itemSummaryView-DIM-general-keywords">
        <xsl:choose>
            <xsl:when test="count(dim:field[@element='subject']) &gt; 1 or count(dim:field[@element='subject']) = 1">
                <xsl:choose>
                    <xsl:when test="count(dim:field[@element='subject'][not(@qualifier)][@language='']) &gt; 1">
                        <div class="simple-item-view-keywords item-page-field-wrapper table">
                            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-subject</i18n:text></h4>
                            <div>
                                <xsl:for-each select="dim:field[@element='subject'][not(@qualifier)][@language='']">
                                    <xsl:value-of select="./node()"/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
                                </xsl:for-each>
                            </div>
                        </div>
                    </xsl:when>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="count(dim:field[@element='subject'][not(@qualifier)][@language='cs_CZ']) &gt; 1 or count(dim:field[@element='subject'][not(@qualifier)][@language='cs_CZ']) = 1">
                        <div class="simple-item-view-keywords-cs item-page-field-wrapper table">
                            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-subject-item-view-cs</i18n:text></h4>
                            <div>
                                <xsl:for-each select="dim:field[@element='subject' and @language='cs_CZ']">
                                    <xsl:value-of select="./node()"/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
                                </xsl:for-each>
                            </div>
                        </div>
                    </xsl:when>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="count(dim:field[@element='subject'][not(@qualifier)][@language='en_US']) &gt; 1 or count(dim:field[@element='subject'][not(@qualifier)][@language='en_US']) = 1">
                        <div class="simple-item-view-keywords-en item-page-field-wrapper table">
                            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-subject-item-view-en</i18n:text></h4>
                            <div>
                                <xsl:for-each select="dim:field[@element='subject' and @language='en_US']">
                                    <xsl:value-of select="./node()"/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
                                </xsl:for-each>
                            </div>
                        </div>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <div class="simple-item-view-keywords item-page-field-wrapper table">
                    <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-subject</i18n:text></h4>
                    <xsl:choose>
                        <xsl:when test="$active-locale='cs'">
                            <xsl:text>Klíčová slova nejsou k dispozici</xsl:text>
                        </xsl:when>
                        <xsl:when test="$active-locale='en'">
                            <xsl:text>Keywords not found</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Keywords not found</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--    END OF: KEYWORDS (GENERAL)  -->

    <!--    KEYWORDS (CS)   -->
    <!-- <JR> - 20. 2. 2017 -->
    <xsl:template name="itemSummaryView-DIM-general-keywords-cs">
        
        <div class="simple-item-view-description item-page-field-wrapper table">
            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-subject-item-view-cs</i18n:text></h4>
            <div>
                <xsl:choose>
                    <xsl:when test="count(dim:field[@element='subject'][not(@qualifier)]) &gt; 1">
                        <xsl:for-each select="dim:field[@element='subject' and @language='cs_CZ']">
                            <xsl:value-of select="./node()"/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$active-locale='en'">
                                <xsl:text>Information unavailable</xsl:text>
                            </xsl:when>
                            <xsl:when test="$active-locale='cs'">
                                <xsl:text>Informace není k dispozici</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Information unavailable</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>
        
    </xsl:template>
    <!-- <JR> - 20. 2. 2017 -->
    <xsl:template name="itemSummaryView-DIM-general-keywords-en">
        
        <div class="simple-item-view-description item-page-field-wrapper table">
            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-subject-item-view-en</i18n:text></h4>
            <div>
                <xsl:choose>
                    <xsl:when test="count(dim:field[@element='subject'][not(@qualifier)]) &gt; 1">
                        <xsl:for-each select="dim:field[@element='subject' and @language='en_US']">
                            <xsl:value-of select="./node()"/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$active-locale='en'">
                                <xsl:text>Information unavailable</xsl:text>
                            </xsl:when>
                            <xsl:when test="$active-locale='cs'">
                                <xsl:text>Informace není k dispozici</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Information unavailable</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>

    </xsl:template>
    <!-- END OF: KEYWORDS (CS)  -->

    <!-- FILES METADATA -->
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

    <!--    ISSUE DATE    -->
    <xsl:template name="itemSummaryView-DIM-general-date">
        <div class="simple-item-view-date word-break item-page-field-wrapper table">
            <h4 class="item-view-heading">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-date-issued</i18n:text>
            </h4>
            <xsl:choose>
                <xsl:when test="dim:field[@element='date' and @qualifier='issued' and descendant::text()]">
                    <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
                        <xsl:copy-of select="substring(./node(),1,10)"/>
                        <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$active-locale='en'">
                            <xsl:text>Information unavailable</xsl:text>
                        </xsl:when>
                        <xsl:when test="$active-locale='cs'">
                            <xsl:text>Informace není k dispozici</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Information unavailable</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <!--    END OF: GENERAL DATE    -->

    <!-- SOURCE DATA -->
    <xsl:template name="itemSummaryView-DIM-general-source-data">
        <xsl:choose>
            <xsl:when test="dim:field[@element='source'][not(@qualifier)]">
                <xsl:value-of select="dim:field[@element='source'][not(@qualifier)]"/>
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
    </xsl:template>
    <!-- END OF: SOURCE -->

    <!-- SOURCE URL DATA -->

    <xsl:template name="itemSummaryView-DIM-general-source-url-data">
        
        <xsl:choose>
            <xsl:when test="dim:field[@element='source'][@qualifier='uri']">
                <xsl:variable name="periodical-url" select="dim:field[@element='source'][@qualifier='uri']"/>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$periodical-url"/>
                    </xsl:attribute>
                    <xsl:attribute name="target">
                        <xsl:text>_blank</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="$periodical-url"/>
                </a>
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
        
    </xsl:template>
    <!-- END OF: SOURCE URL -->

    <!-- PUBLISHER -->
    <xsl:template name="itemSummaryView-DIM-general-publisher">
        <div class="simple-item-view-publisher item-page-field-wrapper table">
            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-publisher</i18n:text></h4>
            <xsl:choose>
                <xsl:when test="dim:field[@element='publisher']">
                    <xsl:value-of select="dim:field[@element='publisher']"/>
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
    <!-- END OF: PUBLISHER -->

    <!-- RIGHTS -->
    <xsl:template name="itemSummaryView-DIM-general-rights">
        <div class="simple-item-view-rights item-page-field-wrapper table">
            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-rights</i18n:text></h4>
            <xsl:choose>
                <xsl:when test="dim:field[@element='rights']">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="dim:field[@element='rights']"/>
                        </xsl:attribute>
                        <xsl:attribute name="target">
                            <xsl:text>_blank</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="dim:field[@element='rights']"/>
                    </a>
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
    <!-- END OF: RIGHTS -->

    <!-- ABSTRACT - GENERAL -->
    <xsl:template name="itemSummaryView-DIM-general-abstract">
        <xsl:choose>
            <xsl:when test="dim:field[@element='description'][@qualifier='abstract'][@language='cs_CZ']">
                <xsl:call-template name="itemSummaryView-DIM-general-abstract-structure">
                    <xsl:with-param name="abstract-data">
                        <xsl:value-of select="dim:field[@element='description'][@qualifier='abstract'][@language='cs_CZ']"/>
                    </xsl:with-param>
                    <xsl:with-param name="language">
                        <xsl:text>cs</xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="dim:field[@element='abstract'][@qualifier='cs']">
                <xsl:call-template name="itemSummaryView-DIM-general-abstract-structure">
                    <xsl:with-param name="abstract-data">
                        <xsl:value-of select="dim:field[@element='abstract'][@qualifier='cs']"/>
                    </xsl:with-param>
                    <xsl:with-param name="language">
                        <xsl:text>cs</xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- pass -->
            </xsl:otherwise>
        </xsl:choose>
            
        <xsl:choose>
            <xsl:when test="dim:field[@element='description'][@qualifier='abstract'][@language='en_US']">
                <xsl:call-template name="itemSummaryView-DIM-general-abstract-structure">
                    <xsl:with-param name="abstract-data">
                        <xsl:value-of select="dim:field[@element='description'][@qualifier='abstract'][@language='en_US']"/>
                    </xsl:with-param>
                    <xsl:with-param name="language">
                        <xsl:text>en</xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="dim:field[@element='abstract'][@qualifier='en']">
                <xsl:call-template name="itemSummaryView-DIM-general-abstract-structure">
                    <xsl:with-param name="abstract-data">
                        <xsl:value-of select="dim:field[@element='abstract'][@qualifier='en']"/>
                    </xsl:with-param>
                    <xsl:with-param name="language">
                        <xsl:text>en</xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- pass -->
            </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
            <xsl:when test="dim:field[@element='description'][@qualifier='abstract'][not(@language='en_US') and not(@language='cs_CZ')]">
                <xsl:call-template name="itemSummaryView-DIM-general-abstract-structure">
                    <xsl:with-param name="abstract-data">
                        <xsl:value-of select="dim:field[@element='description'][@qualifier='abstract'][@language='' and not(@language='cs_CZ') and not(@language='en_US')]"/>
                    </xsl:with-param>
                    <xsl:with-param name="language">
                        <xsl:text>original</xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="dim:field[@element='abstract'][@qualifier='original']">
                <xsl:call-template name="itemSummaryView-DIM-general-abstract-structure">
                    <xsl:with-param name="abstract-data">
                        <xsl:value-of select="dim:field[@element='abstract'][@qualifier='original']"/>
                    </xsl:with-param>
                    <xsl:with-param name="language">
                        <xsl:text>original</xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- pass -->
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <!-- END OF: ABSTRACT - GENERAL -->

    <!-- ABSTRACT - STRUCTURE -->
    <xsl:template name="itemSummaryView-DIM-general-abstract-structure">
        <xsl:param name="abstract-data"/>
        <xsl:param name="language"/>
        <xsl:variable name="tab-id" select="concat('panel-abstract','-',$language)"/>
        <xsl:variable name="toggle-href" select="concat('#abstract-collapse','-',$language)"/>
        <xsl:variable name="aria-labelled-by" select="concat('abstract-collapse','-',$language)"/>
        <xsl:variable name="i18n-message" select="concat('xmlui.dri2xhtml.METS-1.0.item-abstract-item-view','-',$language)"/>
        <xsl:variable name="panel-id" select="concat('abstract-collapse','-',$language)"/>
        <xsl:variable name="panel-aria-labelled-by" select="concat('panel-abstract','-',$language)"/>

        
        <div class="simple-item-view-abstract item-page-field-wrapper table">
            <div role="tab" id="{$tab-id}">
                <h4 class="item-view-heading">
                    <a role="button" data-toggle="collapse" href="{$toggle-href}" aria-expanded="true" aria-labelledby="{$aria-labelled-by}">
                        <i18n:text><xsl:value-of select="$i18n-message"/></i18n:text>
                        <span class="glyphicon glyphicon-collapse-down pull-right"></span>
                    </a>
                </h4>
            </div>

            <div id="{$panel-id}" class="panel-collapse collapse out" role="tabpanel" aria-labelledby="{$panel-aria-labelled-by}">
                <div>
                    <xsl:call-template name="itemSummaryView-DIM-general-abstract-data">
                        <xsl:with-param name="abstract-data" select="$abstract-data"/>
                        <!--<xsl:with-param name="language" select="$language"/>-->
                    </xsl:call-template>
                </div>
            </div>
        </div>
        
    </xsl:template>
    <!-- END OF: ABSTRACT - STRUCTURE -->

    <xsl:template name="itemSummaryView-DIM-general-abstract-data">
        <xsl:param name="abstract-data"/>
        <!--<xsl:param name="language"/>-->
        
       <xsl:value-of select="$abstract-data"/>
    </xsl:template>
    <!-- END OF: ABSTRACT - DATA -->

</xsl:stylesheet>