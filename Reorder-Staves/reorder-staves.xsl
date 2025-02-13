<?xml version="1.0" encoding="UTF-8"?>
<stylesheet exclude-result-prefixes="xs xd dme functx dita mei map array" extension-element-prefixes="ixsl" version="3.0" xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:dita="http://dita-ot.sourceforge.net" xmlns:dme="http://www.mozarteum.at/ns/dme" xmlns:functx="http://www.functx.com" xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:mei="http://www.music-encoding.org/ns/mei" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.music-encoding.org/ns/mei">

  <include href="basic.xsl"/>


  <param as="xs:string" name="P_SOURCE" />
  <param as="xs:string?" name="P_STAVES_MAPPING"/>

  <!--This parameter is a needed for XSpec. Cf. https://github.com/xspec/xspec/wiki/Global-Context-Item-->
  <param name="global-context-item" select="."/>

  <xd:doc>
    <xd:desc>
      <xd:p>Replace current scoreDef with the alternative. Note that this should be defined in the following-sibling &lt;choice&gt;.</xd:p>
    </xd:desc>
  </xd:doc>
  <template match="scoreDef[not(@corresp = concat('#', $P_SOURCE))]">
    <copy-of select="following-sibling::choice[@type = 'scoring']/*[@corresp = concat('#', $P_SOURCE)]/scoreDef"/>
  </template>

  <xd:doc>
    <xd:desc/>
  </xd:doc>
  <template match="choice[@type = 'scoring']"/>

  <xd:doc>
    <xd:desc>
      <xd:p>Map staffDef@n of the new scoreDef and @dme.parts.</xd:p>
    </xd:desc>
  </xd:doc>
  <variable as="map(xs:string, xs:double)*" name="map_staves_order">
    <choose>
      <when test="string-length($P_STAVES_MAPPING) > 0">
        <message>Using staves mapping from the parameter $P_STAVES_MAPPING!</message>
        <sequence select="parse-json($P_STAVES_MAPPING)"/>
      </when>
      <otherwise>
        <message>Using staves mapping from config-staves-mapping.json!</message>
        <sequence select="json-doc('config-staves-mapping.json')"/>
      </otherwise>
    </choose>
  </variable>

  <xd:doc>
    <xd:desc>
      <xd:p>Get the maximum number of staves.</xd:p>
    </xd:desc>
  </xd:doc>
  <variable as="xs:integer" name="count_staves" select="
      max(for $a in map:keys($map_staves_order)
      return
        xs:integer($a))"/>

  <xd:doc>
    <xd:desc>
      <xd:p>Key: old @n.</xd:p>
      <xd:p>Value: new @n</xd:p>
    </xd:desc>
  </xd:doc>
  <!--<variable as="map(xs:string, xs:string)*" name="map_new_old_staves">
    <map>
      <for-each select="map:keys($map_staves_order)">
        <variable name="current_key" select="."/>
        <map-entry key="$global-context-item//mei:measure[@n = 1]/mei:staff[@dme.parts = map:get($map_staves_order, $current_key)]/@n/string()" select="."/>
      </for-each>
    </map>
  </variable>-->


  <xd:doc>
    <xd:desc>
      <xd:p>Copies elements before first staff without changes, e.g. &lt;tempo&gt;</xd:p>
      <xd:p>Copies staves accordingly to the new score order. Changes the @n-attribute accordingly</xd:p>
      <xd:p>Copies ControlEvents and updates the @staff attribute if neccessary.</xd:p>
    </xd:desc>
  </xd:doc>
  <template match="measure">
    <copy>
      <apply-templates select="@*"/>
      <apply-templates select="child::staff[1]/preceding-sibling::*"/>

      <variable as="element()" name="currentMeasure" select="."/>

      <for-each select="1 to $count_staves">
        <variable name="currentItem" select="."/>
        <for-each select="$currentMeasure/child::staff[map:get($map_staves_order, xs:string(@n)) = $currentItem]">
          <copy>
            <attribute name="n" select="$currentItem"/>
            <apply-templates select="(@* except @n) | node()"/>
          </copy>
        </for-each>
      </for-each>

      <call-template name="update_staff_controlEvents">
        <with-param name="elements" select="child::staff[last()]/following-sibling::*"/>
      </call-template>

    </copy>
  </template>



  <xd:doc>
    <xd:desc>
      <xd:p>Receives one or more elements (controlEvents) and updates their @staff according to the $map_new_old_staves variable.</xd:p>
      <xd:p>Recursive template</xd:p>
    </xd:desc>
    <xd:param name="elements"/>
  </xd:doc>
  <template name="update_staff_controlEvents">
    <param name="elements"/>

    <for-each select="$elements">
      <choose>
        <when test="@staff">
          <copy>
            <attribute name="staff" select="map:get($map_staves_order, xs:string(@staff))"/>
            <apply-templates select="@* except @staff"/>
            <if test="node()">
              <call-template name="update_staff_controlEvents">
                <with-param name="elements" select="node()"/>
              </call-template>
            </if>
          </copy>
        </when>
        <otherwise>
          <copy>
            <apply-templates select="@*"/>
            <if test="node()">
              <call-template name="update_staff_controlEvents">
                <with-param name="elements" select="node()"/>
              </call-template>
            </if>
          </copy>
        </otherwise>
      </choose>
    </for-each>

  </template>

</stylesheet>
