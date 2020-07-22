<?xml version="1.0" encoding="UTF-8" ?>
<!-- 


    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/
	Developed by DSpace @ Lyncode <dspace@lyncode.com>
	
	> http://www.openarchives.org/OAI/2.0/oai_dc.xsd

 -->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:doc="http://www.lyncode.com/xoai"
	version="1.0">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes" />
	
	<xsl:template match="/">
		<oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" 
			xmlns:dc="http://purl.org/dc/elements/1.1/" 
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
			xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
			<!-- dc.title -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='title']/doc:element/doc:field[@name='value']">
				<dc:title><xsl:value-of select="." /></dc:title>
			</xsl:for-each>
			<!-- dc.title.translated -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='title']/doc:element[@name='translated']/doc:element/doc:field[@name='value']">
				<dc:title><xsl:value-of select="." /></dc:title>
			</xsl:for-each>
			<!-- dc.title.* -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='title']/doc:element/doc:element/doc:field[@name='value']">
				<dc:title-alternative><xsl:value-of select="." /></dc:title-alternative>
			</xsl:for-each> -->
			<!-- dc.creator -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='creator']/doc:element/doc:field[@name='value']">
				<dc:creator><xsl:value-of select="." /></dc:creator>
			</xsl:for-each>
			<!-- dc.contributor.author -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='author']/doc:element/doc:field[@name='value']">
				<dc:creator><xsl:value-of select="." /></dc:creator>
			</xsl:for-each>
			<!-- dc.contributor.* (!advisor and not opponent / referee) -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name!='advisor' or @name!='opponent' or @name!='referee']/doc:element/doc:field[@name='value']">
				<dc:contributor><xsl:value-of select="." /></dc:contributor>
			</xsl:for-each>
			<!-- dc.contributor -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element/doc:field[@name='value']">
				<dc:contributor><xsl:value-of select="." /></dc:contributor>
			</xsl:for-each>
			<!-- dc.publisher & dc.publisher.place-->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='publisher']/doc:element/doc:field[@name='value']">
				<dc:publisher>
					<xsl:value-of select="." />
					<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='publisher']/doc:element[@name='place']/doc:element/doc:field[@name='value']">
						<xsl:value-of select="." />
					</xsl:for-each>
				</dc:publisher>
			</xsl:for-each>
			<!-- dc.date.issued -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element[@name='issued']/doc:element/doc:field[@name='value']">
				<dc:date><xsl:value-of select="." /></dc:date>
			</xsl:for-each>
			<!-- dc.language.iso -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='language']/doc:element[@name='iso']/doc:element/doc:field[@name='value']">
				<dc:language><xsl:value-of select="." /></dc:language>
			</xsl:for-each>
			<!-- dc.subject -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='subject']/doc:element/doc:field[@name='value']">
				<dc:subject><xsl:value-of select="." /></dc:subject>
			</xsl:for-each>
			<!-- dc.subject.* -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='subject']/doc:element/doc:element/doc:field[@name='value']">
				<dc:subject><xsl:value-of select="." /></dc:subject>
			</xsl:for-each>
			<!-- dc.type -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='type']/doc:element/doc:field[@name='value']">
				<dc:type><xsl:value-of select="." /></dc:type>
			</xsl:for-each>
			<!-- dc.identifier.aleph -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='aleph']/doc:element/doc:field[@name='value'">
				<dc:identifier.lis><xsl:value-of select="." /></dc:identifier.lis>
			</xsl:for-each>
			<!-- dc.identifier.isbn -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='isbn']/doc:element/doc:field[@name='value'">
				<dc:identifier.isbn><xsl:value-of select="." /></dc:identifier.isbn>
			</xsl:for-each>
			<!-- dc.identifier.issn -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='issn']/doc:element/doc:field[@name='value'">
				<dc:identifier.issn><xsl:value-of select="." /></dc:identifier.issn>
			</xsl:for-each>
			<!-- others.handle -->
			<xsl:for-each select="doc:metadata/doc:element[@name='others']/doc:field[@name='handle'">
				<dc:identifier.sourceSystem><xsl:value-of select="." /></dc:identifier.sourceSystem>
			</xsl:for-each>
			<!-- others.lastModifyDate -->
			<xsl:for-each select="doc:metadata/doc:element[@name='others']/doc:field[@name='lastModifyDate'">
				<dc:date.lastModified><xsl:value-of select="." /></dc:date.lastModified>
			</xsl:for-each>

			
			


			<!-- THESIS SPECIFIC -->
			<!-- dc.contributor.advisor -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='advisor']/doc:element/doc:field[@name='value']">
				<dc:advisor><xsl:value-of select="." /></dc:advisor>
			</xsl:for-each> -->
			<!-- dc.contributor.opponent -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='opponent']/doc:element/doc:field[@name='value']">
				<dc:opponent><xsl:value-of select="." /></dc:opponent>
			</xsl:for-each> -->
			
			<!-- dc.contributor.* (!opponent) -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name!='opponent']/doc:element/doc:field[@name='value']"> -->
				<!-- <dc:contributor><xsl:value-of select="." /></dc:contributor> -->
			<!-- </xsl:for-each> -->
			
			<!-- dc.publisher -->
			<!--<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='publisher']/doc:element/doc:field[@name='value']">
				<dc:publisher><xsl:value-of select="." /></dc:publisher>
			</xsl:for-each>-->
			
			<!-- dc.description -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element/doc:field[@name='value']">
				<dc:description><xsl:value-of select="." /></dc:description>
			</xsl:for-each> -->
			<!-- dc.description.abstract-->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='abstract']/doc:element/doc:field[@name='value']">
				<dc:abstract><xsl:value-of select="." /></dc:abstract>
			</xsl:for-each> -->
			<!-- dc.description.faculty-->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='faculty']/doc:element/doc:field[@name='value']">
				<dc:faculty><xsl:value-of select="." /></dc:faculty>
			</xsl:for-each> -->
			<!-- dc.description.department -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='department']/doc:element/doc:field[@name='value']">
				<dc:department><xsl:value-of select="." /></dc:department>
			</xsl:for-each> -->
			<!-- dc.date -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element/doc:field[@name='value']">
				<dc:date><xsl:value-of select="." /></dc:date>
			</xsl:for-each> -->
			
			
			<!-- dc.type.* -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='type']/doc:element/doc:element/doc:field[@name='value']">
				<dc:type><xsl:value-of select="." /></dc:type>
			</xsl:for-each> -->
			<!-- dc.identifier -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element/doc:field[@name='value']">
				<dc:identifier><xsl:value-of select="." /></dc:identifier>
			</xsl:for-each> -->
			<!-- dc.identifier.* -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element/doc:element/doc:field[@name='value']">
				<dc:identifier><xsl:value-of select="." /></dc:identifier>
			</xsl:for-each> -->
			
			<!-- dc.language.* -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='language']/doc:element/doc:element/doc:field[@name='value']">
				<dc:language><xsl:value-of select="." /></dc:language>
			</xsl:for-each> -->
			<!-- dc.relation -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='relation']/doc:element/doc:field[@name='value']">
				<dc:relation><xsl:value-of select="." /></dc:relation>
			</xsl:for-each> -->
			<!-- dc.relation.* -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='relation']/doc:element/doc:element/doc:field[@name='value']">
				<dc:relation><xsl:value-of select="." /></dc:relation>
			</xsl:for-each> -->
			<!-- dc.rights -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field[@name='value']">
				<dc:rights><xsl:value-of select="." /></dc:rights>
			</xsl:for-each> -->
			<!-- dc.rights.* -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:element/doc:field[@name='value']">
				<dc:rights><xsl:value-of select="." /></dc:rights>
			</xsl:for-each> -->
			<!-- dc.format -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='format']/doc:element/doc:field[@name='value']">
				<dc:format><xsl:value-of select="." /></dc:format>
			</xsl:for-each> -->
			<!-- dc.format.* -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='format']/doc:element/doc:element/doc:field[@name='value']">
				<dc:format><xsl:value-of select="." /></dc:format>
			</xsl:for-each> -->
			<!-- ? -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='bitstreams']/doc:element[@name='bitstream']/doc:field[@name='format']">
				<dc:format><xsl:value-of select="." /></dc:format>
			</xsl:for-each> -->
			<!-- dc.coverage -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='coverage']/doc:element/doc:field[@name='value']">
				<dc:coverage><xsl:value-of select="." /></dc:coverage>
			</xsl:for-each> -->
			<!-- dc.coverage.* -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='coverage']/doc:element/doc:element/doc:field[@name='value']">
				<dc:coverage><xsl:value-of select="." /></dc:coverage>
			</xsl:for-each> -->
			
			<!-- dc.publisher.* -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='publisher']/doc:element/doc:element/doc:field[@name='value']">
				<dc:publisher><xsl:value-of select="." /></dc:publisher>
			</xsl:for-each> -->
			<!-- dc.source -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='source']/doc:element/doc:field[@name='value']">
				<dc:source><xsl:value-of select="." /></dc:source>
			</xsl:for-each> -->
			<!-- dc.source.* -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='source']/doc:element/doc:element/doc:field[@name='value']">
				<dc:source><xsl:value-of select="." /></dc:source>
			</xsl:for-each> -->
			<!-- dc.thesis.degree-name -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='thesis']/doc:element[@name='degree-name']/doc:element/doc:field[@name='value']">
				<dc:degree><xsl:value-of select="." /></dc:degree>
			</xsl:for-each> -->
			<!-- uk.result.grade -->
			<!-- <xsl:for-each select="doc:metadata/doc:element[@name='uk']/doc:element[@name='result']/doc:element[@name='grade']/doc:element/doc:field[@name='value']">
				<dc:grade><xsl:value-of select="." /></dc:grade>
			</xsl:for-each> -->
		</oai_dc:dc>
	</xsl:template>
</xsl:stylesheet>
