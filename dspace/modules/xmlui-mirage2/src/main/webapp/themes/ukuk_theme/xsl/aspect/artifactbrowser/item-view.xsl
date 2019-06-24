<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->

<!--
    Rendering specific to the item display page.

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov

-->

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
    <xsl:import href="item-view-theses-templates.xsl" />
    <xsl:import href="item-view-articles-templates.xsl" />
    <!--<xsl:import href="item-view-other-templates.xsl" />-->

    <xsl:output indent="yes"/>

    <xsl:template name="itemSummaryView-DIM">
        <!-- Generate the info about the item from the metadata section -->
        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
        mode="itemSummaryView-DIM"/>

        <xsl:copy-of select="$SFXLink" />

        <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default)-->
        <xsl:if test="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']">
            <div class="license-info table">
                <p>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.license-text</i18n:text>
                </p>
                <ul class="list-unstyled">
                    <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']" mode="simple"/>
                </ul>
            </div>
        </xsl:if>


    </xsl:template>
<!-- TEST -->
    <!-- An item rendered in the detailView pattern, the "full item record" view of a DSpace item in Manakin. -->
    <xsl:template name="itemDetailView-DIM">
        <!-- Output all of the metadata about the item from the metadata section -->
        <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                             mode="itemDetailView-DIM"/>

        <!-- Generate the bitstream information from the file section -->
        <xsl:choose>
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h3>
                <div class="file-list">
                    <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE' or @USE='CC-LICENSE']">
                        <xsl:with-param name="context" select="."/>
                        <xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
                    </xsl:apply-templates>
                </div>
            </xsl:when>
            <!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='ORE']">
                <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='ORE']" mode="itemDetailView-DIM" />
            </xsl:when>
            <xsl:otherwise>
                <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
                <table class="ds-table file-list">
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
                        </td>
                    </tr>
                </table>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
        <div class="item-summary-view-metadata">

		<!-- <JR>. 1. 6. 2018 --> 
		<!-- 
		Call template for general information (displayed for every object in DSpace.
		Then, separate templates should be called for theses and publications based
		on the dc.type of the object
		-->
            <xsl:call-template name="itemSummaryView-DIM-general"/>		                
	
        	<xsl:if test="$ds_item_view_toggle_url != ''">
            	<xsl:call-template name="itemSummaryView-show-full"/>
        	</xsl:if>

        </div>
    </xsl:template>

	<xsl:template name="itemSummaryView-DIM-general" >
        <h2 class="page-header first-page-header item-view-header">
            <xsl:call-template name="itemSummaryView-DIM-general-title-first"/>
        </h2>
        <h5 class="item-view-heading-secondary">
            <xsl:call-template name="itemSummaryView-DIM-general-title-all-other"/>
        </h5>
        <!--<div class="simple-item-view-other">
            <p class="lead">
                <xsl:call-template name="itemSummaryView-DIM-general-title-all-other"/>
            </p>
        </div>-->
		<div class="simple-item-view-description item-page-field-wrapper table">
            <div>
                <h4>
                    <xsl:call-template name="itemSummaryView-DIM-general-work-type"/>
                    <xsl:call-template name="itemSummaryView-DIM-theses-defense-status"/>
                </h4>
            </div>
        </div>
    	<div class="row">
        	<div class="col-sm-12">
        		<div class="row">
            		<div class="col-xs-12 col-sm-5">
            			<!--<xsl:call-template name="itemSummaryView-DIM-general-date"/>-->
            			<xsl:call-template name="itemSummaryView-DIM-general-file-section"/>
            			<xsl:call-template name="itemSummaryView-DIM-general-URI"/>
            			<xsl:call-template name="itemSummaryView-general-collections"/>
            		</div>

					<!-- Call doctype handler and create itemView specific for the type of the item that is being displayed -->
					<xsl:call-template name="doctype-handler"/>

				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="doctype-handler">
		
		<!-- Get Document Type (dc.type) -->		
		<xsl:variable name="document_type_en" select="dim:field[@element='type' and @language='en_US']/text()" />
		<xsl:variable name="document_type_cs" select="dim:field[@element='type' and @language='cs_CZ']/text()" />
		<xsl:variable name="document_type_nolang" select="dim:field[@element='type'][not(@language)]/text()" />
        <xsl:variable name="document_type_internal" select="dim:field[@element='internal-type']/text()" />
		
		<!-- Checking document type -->
		<xsl:choose>
			<xsl:when test="($document_type_en = 'bachelor thesis') or ($document_type_en='diploma thesis') or ($document_type_en = 'disertation thesis') or ($document_type_en = 'doctoral thesis') or ($document_type_en = 'rigorous work') or ($document_type_en = 'rigorous thesis') or ($document_type_en = 'habilitation thesis')">
				<!-- English document type of the object was found in english thesis types list -->					
				<!-- It's a thesis!!! -->
				
				<xsl:call-template name="itemSummaryView-DIM-theses" />
			</xsl:when>
			<xsl:when test="($document_type_cs = 'bakalářská práce') or ($document_type_cs='diplomová práce') or ($document_type_cs = 'dizertační práce') or ($document_type_cs = 'rigorózní práce') or ($document_type_cs = 'habilitační práce')">
				<!-- Czech document type of the object was found in czech thesis types list -->					
				<!-- It's a thesis!!! -->
				
				<xsl:call-template name="itemSummaryView-DIM-theses" />
			</xsl:when>
			<xsl:when test="($document_type_nolang = 'bachelor thesis') or ($document_type_nolang = 'diploma thesis') or ($document_type_nolang = 'disertation thesis') or ($document_type_nolang = 'doctoral thesis') or ($document_type_nolang = 'rigorous work') or ($document_type_nolang = 'rigorous thesis') or ($document_type_nolang = 'habilitation thesis')">
				<!-- No-language document type of the object was found in english thesis types list -->					
				<!-- It's a thesis!!! -->
				
				<xsl:call-template name="itemSummaryView-DIM-theses" />
			</xsl:when>
			<xsl:when test="($document_type_nolang = 'bakalářská práce') or ($document_type_nolang='diplomová práce') or ($document_type_nolang = 'dizertační práce') or ($document_type_nolang = 'rigorózní práce') or ($document_type_nolang = 'habilitační práce')">
				<!-- No-language document type of the object was found in czech thesis types list -->					
				<!-- It's a thesis!!! -->
				
				<xsl:call-template name="itemSummaryView-DIM-theses" />
			</xsl:when>
			<xsl:when test="($document_type_cs = 'Článek' or $document_type_nolang = 'Článek') or ($document_type_en = 'Article' or $document_type_nolang = 'Article')">
				<!-- It's an Article!!! -->
				<xsl:call-template name="itemSummaryView-DIM-articles" />
			</xsl:when>
            <xsl:when test="$document_type_internal = 'uk_publication'">
                <xsl:call-template name="itemSummaryView-DIM-articles" />
            </xsl:when>
			<xsl:otherwise>
				<!-- Document type was not found in any of the thesis types lists-->
				<!-- It's not a thesis, nor article or any other document type listed above -->
				
				<xsl:call-template name="itemSummaryView-DIM-other" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="itemSummaryView-DIM-theses" >
		<div class="col-xs-12 col-sm-7">
		    <xsl:call-template name="itemSummaryView-DIM-general-authors"/>
		    <xsl:call-template name="itemSummaryView-DIM-theses-advisors"/>
		    <xsl:call-template name="itemSummaryView-DIM-theses-referees"/>
		    <xsl:call-template name="itemSummaryView-DIM-theses-affiliation"/>
		    <xsl:call-template name="itemSummaryView-DIM-theses-faculty"/>
		    <xsl:call-template name="itemSummaryView-DIM-theses-discipline"/>
		    <xsl:call-template name="itemSummaryView-DIM-theses-department"/>
		    <xsl:call-template name="itemSummaryView-DIM-theses-acceptance-date"/>
		    <xsl:call-template name="itemSummaryView-DIM-general-work-language"/>
		    <xsl:call-template name="itemSummaryView-DIM-theses-grade"/>
            <xsl:call-template name="itemSummaryView-DIM-general-keywords"/>
		    <!--<xsl:call-template name="itemSummaryView-DIM-general-keywords-cs"/>
		    <xsl:call-template name="itemSummaryView-DIM-general-keywords-en"/>-->
		</div>
        <div class="col-xs-12 col-sm-12">
            <!--<xsl:call-template name="itemSummaryView-DIM-general-abstract-cs"/>
            <xsl:call-template name="itemSummaryView-DIM-general-abstract-en"/>
            <xsl:call-template name="itemSummaryView-DIM-general-abstract-original"/>-->
            <xsl:call-template name="itemSummaryView-DIM-general-abstract"/>
            <xsl:call-template name="citacePro"/>
        </div>

	</xsl:template>

	<xsl:template name="itemSummaryView-DIM-articles">
		<div class="col-xs-12 col-sm-7">
			<div class="simple-item-view-authors item-apge-field-wrapper table">
				<xsl:call-template name="itemSummaryView-DIM-general-authors"/>
                <xsl:call-template name="itemSummaryView-DIM-general-contributors"/>
                <xsl:call-template name="itemSummaryView-DIM-general-date"/>
		<xsl:call-template name="itemSummaryView-DIM-articles-ISSN"/>
		<xsl:call-template name="itemSummaryView-DIM-articles-DOI"/>
                <xsl:call-template name="itemSummaryView-DIM-periodical-source"/>
                <xsl:call-template name="itemSummaryView-DIM-periodical-source-url"/>
                <xsl:call-template name="itemSummaryView-DIM-general-publisher"/>
                <xsl:call-template name="itemSummaryView-DIM-general-rights"/>
                <xsl:call-template name="itemSummaryView-DIM-general-keywords"/>
			</div>		
		</div>
        <div class="col-xs-12 col-sm-12 col-md-12">
            <xsl:call-template name="itemSummaryView-DIM-general-abstract"/>
        </div>
	</xsl:template>

	<xsl:template name="itemSummaryView-DIM-other">
		<div class="row">
			<div class="col-xs-12 col-sm-7">
				<div class="simple-item-view-authors item-apge-field-wrapper table">
					<h4 class="item-view-heading">Něco jiného!!!</h4>
				</div>		
			</div>
		</div>
	</xsl:template>

	<!-- <JR> - 15. 9. 2017 - new template for CitacePRO -->
    <xsl:template name="citacePro">
            <xsl:variable name="urlPrefix">
                    <xsl:text>https://www.citacepro.com/api/dspaceuk/citace/oai:dspace.cuni.cz:</xsl:text>
            </xsl:variable>

            <h4 class="item-view-heading">
                    <xsl:text>Citace dokumentu</xsl:text>
            </h4>
            <div id="ds-search-option" class="ds-option-set">
                    <embed style="width:100%;height:230px">
                            <xsl:attribute name="src">
                                    <xsl:call-template name="itemSummaryView-DIM-citaceURL">
                                            <xsl:with-param name="prefix" select="$urlPrefix" />
                                    </xsl:call-template>
                            </xsl:attribute>
                    </embed>
            </div>
    </xsl:template>

        <xsl:template name="itemSummaryView-DIM-citaceURL">
                <xsl:param name="prefix" />
                <xsl:variable name="urlPref">
                        <xsl:value-of select="$prefix" />
                </xsl:variable>
                <xsl:variable name="handleId">
                        <xsl:value-of select="$document//dri:meta/dri:pageMeta/dri:metadata[@element='identifier'][@qualifier='handle']"/>
                </xsl:variable>
                <xsl:value-of select="concat($urlPref,$handleId)"/>
        </xsl:template>

    <xsl:template name="itemSummaryView-DIM-thumbnail">
        <div class="thumbnail">
            <xsl:choose>
                <xsl:when test="//mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']">
                    <xsl:variable name="src">
                        <xsl:choose>
                            <xsl:when test="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=../../mets:fileGrp[@USE='CONTENT']/mets:file[@GROUPID=../../mets:fileGrp[@USE='THUMBNAIL']/mets:file/@GROUPID][1]/@GROUPID]">
                                <xsl:value-of
                                        select="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=../../mets:fileGrp[@USE='CONTENT']/mets:file[@GROUPID=../../mets:fileGrp[@USE='THUMBNAIL']/mets:file/@GROUPID][1]/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                        select="//mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <img alt="Thumbnail">
                        <xsl:attribute name="src">
                            <xsl:value-of select="$src"/>
                        </xsl:attribute>
                    </img>
                </xsl:when>
                <xsl:otherwise>
                    <img alt="Thumbnail">
                        <xsl:attribute name="data-src">
                            <xsl:text>holder.js/100%x</xsl:text>
                            <xsl:value-of select="$thumbnail.maxheight"/>
                            <xsl:text>/text:No Thumbnail</xsl:text>
                        </xsl:attribute>
                    </img>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-show-full">
        <div class="simple-item-view-show-full item-page-field-wrapper table">
            <h5>
                <i18n:text>xmlui.mirage2.itemSummaryView.MetaData</i18n:text>
            </h5>
            <a>
                <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
            </a>
        </div>
    </xsl:template>

    <xsl:template match="dim:dim" mode="itemDetailView-DIM">
        <h2 class="page-header first-page-header item-view-header">
            <xsl:call-template name="itemSummaryView-DIM-general-title-first"/>
        </h2>
        <h5 class="item-view-heading-secondary">
            <!--<xsl:call-template name="itemSummaryView-DIM-general-title-translated"/>-->
            <xsl:call-template name="itemSummaryView-DIM-general-title-all-other"/>
        </h5>
        <!--<div class="simple-item-view-other">
            <p class="lead">
                <xsl:call-template name="itemSummaryView-DIM-general-title-all-other"/>
            </p>
        </div>-->
        <div class="ds-table-responsive">
            <table class="ds-includeSet-table detailtable table table-striped table-hover">
                <xsl:apply-templates mode="itemDetailView-DIM"/>
            </table>
        </div>

        <span class="Z3988">
            <xsl:attribute name="title">
                 <xsl:call-template name="renderCOinS"/>
            </xsl:attribute>
            &#xFEFF; <!-- non-breaking space to force separating the end tag -->
        </span>
        <xsl:copy-of select="$SFXLink" />
    </xsl:template>

    <xsl:template match="dim:field" mode="itemDetailView-DIM">
            <tr>
                <xsl:attribute name="class">
                    <xsl:text>ds-table-row </xsl:text>
                    <xsl:if test="(position() div 2 mod 2 = 0)">even </xsl:if>
                    <xsl:if test="(position() div 2 mod 2 = 1)">odd </xsl:if>
                </xsl:attribute>
                <td class="label-cell">
                    <xsl:value-of select="./@mdschema"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="./@element"/>
                    <xsl:if test="./@qualifier">
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="./@qualifier"/>
                    </xsl:if>
                </td>
            <td class="word-break">
              <xsl:copy-of select="./node()"/>
            </td>
                <td><xsl:value-of select="./@language"/></td>
            </tr>
    </xsl:template>

    <!-- don't render the item-view-toggle automatically in the summary view, only when it gets called -->
    <xsl:template match="dri:p[contains(@rend , 'item-view-toggle') and
        (preceding-sibling::dri:referenceSet[@type = 'summaryView'] or following-sibling::dri:referenceSet[@type = 'summaryView'])]">
    </xsl:template>

    <!-- don't render the head on the item view page -->
    <xsl:template match="dri:div[@n='item-view']/dri:head" priority="5">
    </xsl:template>

   <xsl:template match="mets:fileGrp[@USE='CONTENT']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
            <xsl:choose>
                <!-- If one exists and it's of text/html MIME type, only display the primary bitstream -->
                <xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/html'">
                    <xsl:apply-templates select="mets:file[@ID=$primaryBitstream]">
                        <xsl:with-param name="context" select="$context"/>
                    </xsl:apply-templates>
                </xsl:when>
                <!-- Otherwise, iterate over and display all of them -->
                <xsl:otherwise>
                    <xsl:apply-templates select="mets:file">
                     	<!--Do not sort any more bitstream order can be changed-->
                        <xsl:with-param name="context" select="$context"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>

   <xsl:template match="mets:fileGrp[@USE='LICENSE']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
            <xsl:apply-templates select="mets:file">
                        <xsl:with-param name="context" select="$context"/>
            </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="mets:file">
        <xsl:param name="context" select="."/>
        <div class="file-wrapper row">
            <div class="col-xs-6 col-sm-3">
                <div class="thumbnail">
                    <a class="image-link">
                        <xsl:attribute name="href">
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                        mets:file[@GROUPID=current()/@GROUPID]">
                                <img alt="Thumbnail">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                    mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:otherwise>
                                <img alt="Thumbnail">
                                    <xsl:attribute name="data-src">
                                        <xsl:text>holder.js/100%x</xsl:text>
                                        <xsl:value-of select="$thumbnail.maxheight"/>
                                        <xsl:text>/text:No Thumbnail</xsl:text>
                                    </xsl:attribute>
                                </img>
                            </xsl:otherwise>
                        </xsl:choose>
                    </a>
                </div>
            </div>

            <div class="col-xs-6 col-sm-7">
                <dl class="file-metadata dl-horizontal">
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-name</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:attribute name="title">
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                        </xsl:attribute>
                        <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:title, 30, 5)"/>
                    </dd>
                <!-- File size always comes in bytes and thus needs conversion -->
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:choose>
                            <xsl:when test="@SIZE &lt; 1024">
                                <xsl:value-of select="@SIZE"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div 1024),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </dd>
                <!-- Lookup File Type description in local messages.xml based on MIME Type.
         In the original DSpace, this would get resolved to an application via
         the Bitstream Registry, but we are constrained by the capabilities of METS
         and can't really pass that info through. -->
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:call-template name="getFileTypeDesc">
                            <xsl:with-param name="mimetype">
                                <xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
                                <xsl:text>/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="contains(@MIMETYPE,';')">
                                <xsl:value-of select="substring-before(substring-after(@MIMETYPE,'/'),';')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
                                    </xsl:otherwise>
                                </xsl:choose>

                            </xsl:with-param>
                        </xsl:call-template>
                    </dd>
                <!-- Display the contents of 'Description' only if bitstream contains a description -->
                <xsl:if test="mets:FLocat[@LOCTYPE='URL']/@xlink:label != ''">
                        <dt>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-description</i18n:text>
                            <xsl:text>:</xsl:text>
                        </dt>
                        <dd class="word-break">
                            <xsl:attribute name="title">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>
                            </xsl:attribute>
                            <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:label, 30, 5)"/>
                        </dd>
                </xsl:if>
                </dl>
            </div>

            <div class="file-link col-xs-6 col-xs-offset-6 col-sm-2 col-sm-offset-0">
                <xsl:choose>
                    <xsl:when test="@ADMID">
                        <xsl:call-template name="display-rights"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="view-open"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>

</xsl:template>

    <xsl:template name="view-open">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
            </xsl:attribute>
            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
        </a>
    </xsl:template>

    <xsl:template name="display-rights">
        <xsl:variable name="file_id" select="jstring:replaceAll(jstring:replaceAll(string(@ADMID), '_METSRIGHTS', ''), 'rightsMD_', '')"/>
        <xsl:variable name="rights_declaration" select="../../../mets:amdSec/mets:rightsMD[@ID = concat('rightsMD_', $file_id, '_METSRIGHTS')]/mets:mdWrap/mets:xmlData/rights:RightsDeclarationMD"/>
        <xsl:variable name="rights_context" select="$rights_declaration/rights:Context"/>
        <xsl:variable name="users">
            <xsl:for-each select="$rights_declaration/*">
                <xsl:value-of select="rights:UserName"/>
                <xsl:choose>
                    <xsl:when test="rights:UserName/@USERTYPE = 'GROUP'">
                       <xsl:text> (group)</xsl:text>
                    </xsl:when>
                    <xsl:when test="rights:UserName/@USERTYPE = 'INDIVIDUAL'">
                       <xsl:text> (individual)</xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="not ($rights_context/@CONTEXTCLASS = 'GENERAL PUBLIC') and ($rights_context/rights:Permissions/@DISPLAY = 'true')">
                <a href="{mets:FLocat[@LOCTYPE='URL']/@xlink:href}">
                    <img width="64" height="64" src="{concat($theme-path,'/images/Crystal_Clear_action_lock3_64px.png')}" title="Read access available for {$users}"/>
                    <!-- icon source: http://commons.wikimedia.org/wiki/File:Crystal_Clear_action_lock3.png -->
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="view-open"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getFileIcon">
        <xsl:param name="mimetype"/>
            <i aria-hidden="true">
                <xsl:attribute name="class">
                <xsl:text>glyphicon </xsl:text>
                <xsl:choose>
                    <xsl:when test="contains(mets:FLocat[@LOCTYPE='URL']/@xlink:href,'isAllowed=n')">
                        <xsl:text> glyphicon-lock</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> glyphicon-file</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:attribute>
            </i>
        <xsl:text> </xsl:text>
    </xsl:template>

    <!-- Generate the license information from the file section -->
    <xsl:template match="mets:fileGrp[@USE='CC-LICENSE']" mode="simple">
        <li><a href="{mets:file/mets:FLocat[@xlink:title='license_text']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_cc</i18n:text></a></li>
    </xsl:template>

    <!-- Generate the license information from the file section -->
    <xsl:template match="mets:fileGrp[@USE='LICENSE']" mode="simple">
        <li><a href="{mets:file/mets:FLocat[@xlink:title='license.txt']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_original_license</i18n:text></a></li>
    </xsl:template>

    <!--
    File Type Mapping template

    This maps format MIME Types to human friendly File Type descriptions.
    Essentially, it looks for a corresponding 'key' in your messages.xml of this
    format: xmlui.dri2xhtml.mimetype.{MIME Type}

    (e.g.) <message key="xmlui.dri2xhtml.mimetype.application/pdf">PDF</message>

    If a key is found, the translated value is displayed as the File Type (e.g. PDF)
    If a key is NOT found, the MIME Type is displayed by default (e.g. application/pdf)
    -->
    <xsl:template name="getFileTypeDesc">
        <xsl:param name="mimetype"/>

        <!--Build full key name for MIME type (format: xmlui.dri2xhtml.mimetype.{MIME type})-->
        <xsl:variable name="mimetype-key">xmlui.dri2xhtml.mimetype.<xsl:value-of select='$mimetype'/></xsl:variable>

        <!--Lookup the MIME Type's key in messages.xml language file.  If not found, just display MIME Type-->
        <i18n:text i18n:key="{$mimetype-key}"><xsl:value-of select="$mimetype"/></i18n:text>
    </xsl:template>

    <!-- <JR> - 21. 2. 2017 -->
    <!-- Format date helper template -->

    <xsl:template name="formatdate">

        <xsl:param name="DateTimeStr" />
        <xsl:variable name="datestr">
            <xsl:value-of select="$DateTimeStr" />
        </xsl:variable>

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
    </xsl:template>

</xsl:stylesheet>
