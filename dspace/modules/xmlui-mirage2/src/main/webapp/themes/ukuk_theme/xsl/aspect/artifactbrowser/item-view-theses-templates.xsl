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
                    <xsl:when test="node()/text()='Prospěl/a'">
                        <xsl:text> [</xsl:text>
                        <span class="text-theses-defended">
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text>
                        </span>
                        <xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:when test="node()/text()='Uspokojivě'">
                        <xsl:text> [</xsl:text>
                        <span class="text-theses-defended">
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text>
                        </span>
                        <xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:when test="node()/text()='Dostatečně'">
                        <xsl:text> [</xsl:text>
                        <span class="text-theses-defended">
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-defended-item-view</i18n:text>
                        </span>
                        <xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> [</xsl:text>
                        <span class="text-theses-failed">
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-defense-status-not-defended-item-view</i18n:text>
                        </span>
                        <xsl:text>]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- <JR> - 21. 2. 2017 -->
    <!-- THESIS ADVISORS -->
    <xsl:template name="itemSummaryView-DIM-theses-advisors">
        <!-- # TODO: Upravit šablonu tak, aby se v nadpis metadatového údaje zobrazoval pokaždé a aby se v případě chybějící
        hodnoty zobrazil text "Informace není k dispozici"
        --> 
        <xsl:if test="dim:field[@element='contributor' and @qualifier='advisor' and descendant::text()]">
            <div class="simple-item-view-authors item-page-field-wrapper table">
                <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-advisor-item-view</i18n:text></h4>
                <xsl:for-each select="dim:field[@element='contributor' and @qualifier='advisor']">
                    <xsl:call-template name="itemSummaryView-DIM-theses-advisors-entry" />
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-theses-advisors-entry">
        <div>
            <xsl:if test="@authority">
                <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
            </xsl:if>
            <a>
                <xsl:attribute name="href">
                    <xsl:text>/browse?type=advisor&amp;value=</xsl:text><xsl:copy-of select="./node()"/>
                </xsl:attribute>
                <xsl:copy-of select="node()"/>
            </a>
        </div>
    </xsl:template>
    <!-- END OF: THESIS ADVISORS -->

    <!-- THESIS REFEREES -->
    <!-- <JR> - 21. 2. 2017 -->
    <!-- # TODO: Upravit šablonu tak, aby se v nadpis metadatového údaje zobrazoval pokaždé a aby se v případě chybějící
        hodnoty zobrazil text "Informace není k dispozici"
    -->
    <xsl:template name="itemSummaryView-DIM-theses-referees">
        <xsl:if test="dim:field[@element='contributor' and @qualifier='referee' and descendant::text()]">
            <div class="simple-item-view-authors item-page-field-wrapper table">
                <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-referee-item-view</i18n:text></h4>
                <xsl:for-each select="dim:field[@element='contributor' and @qualifier='referee']">
                    <xsl:call-template name="itemSummaryView-DIM-theses-referees-entry" />
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-theses-referees-entry">
        <div>
            <xsl:if test="@authority">
                <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="node()"/>
        </div>
    </xsl:template>
    <!-- END OF: THESIS REFEREES -->

    <!-- THESIS FACULTY -->
    <!-- <JR> - 20. 2. 2017 -->
    <xsl:template name="itemSummaryView-DIM-theses-faculty">
        <div class="simple-item-view-description item-page-field-wrapper table">
            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-faculty-item-view</i18n:text></h4>
            <div>       
                <xsl:choose>
                    <xsl:when test="$active-locale='en'">           
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='description' and @qualifier='faculty' and (@language='en' or @language='en_US')]">  
                                <xsl:value-of select="dim:field[@element='description' and @qualifier='faculty' and (@language='en' or @language='en_US')]"/>
                            </xsl:when>
                            <xsl:when test="dim:field[@lement='faculty-name' and @qualifier='en']">
                                <xsl:value-of select="dim:field[@element='faculty-name' and @qualifier='en']"/>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='faculty-name' and @qualifier='cs']">
                                <xsl:value-of select="dim:field[@element='faculty-name' and @qualifier='cs']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- TODO: This has to be i18n message key -->
                                <xsl:text>Information unavailable</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$active-locale='cs'">
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='description' and @qualifier='faculty' and (@language='cs' or @language='cs_CZ')]">  
                                <xsl:value-of select="dim:field[@element='description' and @qualifier='faculty' and (@language='cs' or @language='cs_CZ')]"/>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='faculty-name' and @qualifier='cs']">
                                <xsl:value-of select="dim:field[@element='faculty-name' and @qualifier='cs']"/>
                            </xsl:when>
                            <xsl:when test="dim:field[@lement='faculty-name' and @qualifier='en']">
                                <xsl:value-of select="dim:field[@element='faculty-name' and @qualifier='en']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- TODO: This has to be i18n message key -->
                                <xsl:text>Informace není k dispozici</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </div>
        </div>
    </xsl:template>
    <!-- END OF: THESIS FACULTY-->

    <!--    THESIS DISCIPLINE   -->
    <!-- <AM> - 5. 5. 2017 -->
    <xsl:template name="itemSummaryView-DIM-theses-discipline">
        
        <div class="simple-item-view-description item-page-field-wrapper table">
            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-discipline-item-view</i18n:text></h4>
            <div>
                <xsl:choose>
                    <xsl:when test="$active-locale='en'">           
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='degree' and @qualifier='discipline' and (@language='en' or @language='en_US')]">  
                                <xsl:value-of select="dim:field[@element='degree' and @qualifier='discipline' and (@language='en' or @language='en_US')]"/>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='degree' and @qualifier='discipline']">
                                <xsl:value-of select="dim:field[@element='degree' and @qualifier='discipline']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- TODO: This has to be i18n message key -->
                                <xsl:text>Information unavailable</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$active-locale='cs'">
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='degree' and @qualifier='discipline' and (@language='cs' or @language='cs_CZ')]">  
                                <xsl:value-of select="dim:field[@element='degree' and @qualifier='discipline' and (@language='cs' or @language='cs_CZ')]"/>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='degree' and @qualifier='discipline']">
                                <xsl:value-of select="dim:field[@element='degree' and @qualifier='discipline']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- TODO: This has to be i18n message key -->
                                <xsl:text>Informace není k dispozici</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </div>
        </div>
        
    </xsl:template>
    <!--    END OF: THESIS DISCIPLINE   -->

    <!--    THESIS DEPARTMENT   -->
    <!-- <JR> - 20. 2. 2017 -->
    <xsl:template name="itemSummaryView-DIM-theses-department">
            <div class="simple-item-view-description item-page-field-wrapper table">
                <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-department-item-view</i18n:text></h4>
                <div>
                    <xsl:choose>            
                        <xsl:when test="$active-locale='en'">
                            <xsl:choose>
                                <xsl:when test="dim:field[@element='description' and @qualifier='department' and @language='en_US']">
                                    <xsl:value-of select="dim:field[@element='description' and @qualifier='department' and @language='en_US']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Information is unavailable</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="$active-locale='cs'">
                            <xsl:choose>                        
                                <xsl:when test="dim:field[@element='description' and @qualifier='department' and @language='cs_CZ']">
                                    <xsl:value-of select="dim:field[@element='description' and @qualifier='department' and @language='cs_CZ']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Informace není k dispozici</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </div>
            </div>
    </xsl:template>
    <!--    END OF: THESIS DEPARTMENT   -->

    <!--    THESIS ACCEPTANCE DATE  -->
    <!-- <JR> - 21. 2. 2017 -->
    <xsl:template name="itemSummaryView-DIM-theses-acceptance-date">
        <div class="simple-item-view-date item-page-field-wrapper table">
            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-acceptance-date-item-view</i18n:text></h4>
            <div>
                <xsl:choose>
                    <xsl:when test="dim:field[@element='dateAccepted'][not (@qualifier)]">
                        <xsl:choose>
                            <xsl:when test="substring(dim:field[@element='dateAccepted'][not (@qualifier)],9,1) = 0">
                                <xsl:value-of select="substring(dim:field[@element='dateAccepted'][not (@qualifier)],10,1)"/>
                                <xsl:text>. </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring(dim:field[@element='dateAccepted'][not (@qualifier)],9,2)"/>
                                <xsl:text>. </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                
                        <xsl:choose>
                            <xsl:when test="substring(dim:field[@element='dateAccepted'][not (@qualifier)],6,1) = 0">
                                <xsl:value-of select="substring(dim:field[@element='dateAccepted'][not (@qualifier)],7,1)"/>
                                <xsl:text>. </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring(dim:field[@element='dateAccepted'][not (@qualifier)],6,2)"/>
                                <xsl:text>. </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                
                        <xsl:value-of select="substring(dim:field[@element='dateAccepted'][not (@qualifier)],1,4)"/>
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
    <!--    END OF: THESIS ACCEPTANCE DATE  -->

    <!--    THESIS GRADE    -->
    <!-- <JR> - 22. 2. 2017 -->
    <xsl:template name="itemSummaryView-DIM-theses-grade">
            <div class="simple-item-view-description item-page-field-wrapper table">
                <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-grade-item-view</i18n:text></h4>
                <div>
                    <xsl:choose>            
                        <xsl:when test="$active-locale='cs'">
                            <xsl:choose>
                                <xsl:when test="dim:field[@element='grade' and @qualifier='cs']">
                                    <xsl:value-of select="dim:field[@element='grade' and @qualifier='cs']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Informace není k dispozici</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="$active-locale='en'">
                            <xsl:choose>
                                <xsl:when test="dim:field[@element='grade' and @qualifier='en']">
                                    <xsl:value-of select="dim:field[@element='grade' and @qualifier='en']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Information unavailable</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>       
                        </xsl:when>
                    </xsl:choose>
                </div>
            </div>
    </xsl:template>
    <!--    END OF: THESIS GRADE    -->

    <!--    THESIS AFILIATION   -->
    <!-- <AM> - 18. 4. 2017 -->
    <xsl:template name="itemSummaryView-DIM-theses-affiliation">
        <div class="simple-item-view-description item-page-field-wrapper table">
            <h4 class="item-view-heading"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-affiliation-item-view</i18n:text></h4>
            <div>
                <xsl:choose>
                    <xsl:when test="dim:field[@element='author' and @qualifier='affiliation']">
                        <xsl:value-of select="dim:field[@element='author' and @qualifier='affiliation']"/>
                        <xsl:if test="dim:field[@element='author' and @qualifier='affiliation' and @language='en']">
                            <xsl:text> / </xsl:text><xsl:value-of select="dim:field[@element='author' and @qualifier='affiliation' and @language='en']"/>
                        </xsl:if>
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
    <!--    END OF: THESIS AFILIATION   -->
</xsl:stylesheet>