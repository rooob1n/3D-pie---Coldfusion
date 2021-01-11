<cfscript>
	ctxSVG_Data = '';
	lstPathColor = '##9366EE,##FF2100,##FF7700,##8794EA,##f542ef,##44D72F,##18D6AD,##98D6FF';
	lstPathColor = lstPathColor & ',##4261CA,##DB4115,##FE9B00,##009622,##9B0097,##1C95C5,##DD4875,##60AA12';
	lstPathColor = lstPathColor & ',##9A4497,##20A898,##A6AB1C,##6D2ACA,##E57600,##8A170C,##671266,##2F9163';

	lstTextColor = '##ffffff,##ffffff,##000000,##000000,##000000,##000000,##000000,##000000';
	lstTextColor = lstTextColor & ',##000000,##000000,##000000,##000000,##000000,##000000,##000000,##000000';
	lstTextColor = lstTextColor & ',##000000,##000000,##000000,##000000,##000000,##000000,##000000,##000000';

	arrPathColor = ListToArray(lstPathColor);
	arrTextColor = ListToArray(lstTextColor);

    qryCountry = queryNew('ID,CountryName,Cnt',"Varchar,Varchar,Integer");
	QueryAddRow(qryCountry,1);
	QuerySetCell(qryCountry, "ID", 'A', 1);
    QuerySetCell(qryCountry, "CountryName", "Afghanistan", 1);
    QuerySetCell(qryCountry, "Cnt", 22, 1);
    QueryAddRow(qryCountry,1);
	QuerySetCell(qryCountry, "ID", 'B', 2);
    QuerySetCell(qryCountry, "CountryName", "Albania", 2);
    QuerySetCell(qryCountry, "Cnt", 22, 2);
    QueryAddRow(qryCountry,1);
	QuerySetCell(qryCountry, "ID", 'C', 3);
    QuerySetCell(qryCountry, "CountryName", "Algeria", 3);
    QuerySetCell(qryCountry, "Cnt", 22, 3);
	QueryAddRow(qryCountry,1);
	QuerySetCell(qryCountry, "ID", 'D', 4);
    QuerySetCell(qryCountry, "CountryName", "Philippines", 4);
    QuerySetCell(qryCountry, "Cnt", 224, 4);
    QueryAddRow(qryCountry,1);
	QuerySetCell(qryCountry, "ID", 'E', 5);
    QuerySetCell(qryCountry, "CountryName", "China", 5);
    QuerySetCell(qryCountry, "Cnt", 22, 5);
	QueryAddRow(qryCountry,1);
	QuerySetCell(qryCountry, "ID", 'F', 6);
    QuerySetCell(qryCountry, "CountryName", "America", 6);
    QuerySetCell(qryCountry, "Cnt", 22, 6);
    QueryAddRow(qryCountry,1);
	QuerySetCell(qryCountry, "ID", 'G', 7);
    QuerySetCell(qryCountry, "CountryName", "England", 7);
    QuerySetCell(qryCountry, "Cnt", 44, 7);
	QueryAddRow(qryCountry,1);
	QuerySetCell(qryCountry, "ID", 'H', 8);
    QuerySetCell(qryCountry, "CountryName", "Scotland", 8);
    QuerySetCell(qryCountry, "Cnt", 411, 8);
    QueryAddRow(qryCountry,1);
	QuerySetCell(qryCountry, "ID", 'I', 9);
    QuerySetCell(qryCountry, "CountryName", "Russia", 9);
    QuerySetCell(qryCountry, "Cnt", 233, 9);
</cfscript>

<cffunction name="SVGtoPNG" access="public" returntype="any">
	<cfargument name="mSVG_Data" type="string" required="yes">
	<cfscript>
		/*START : Create Image Stream*/
		objPC = getPageContext();
		objPC.setFlushOutput(false);

		objJpgTransCoder = createObject("java", "org.apache.batik.transcoder.image.PNGTranscoder").init();
		objPC.getResponse().getResponse().setContentType('image/png');

		//Multilingual
		mSVG_Data = mSVG_Data.getBytes("UTF-8");
		objFileInputStream = createObject("java", "java.io.ByteArrayInputStream").init(mSVG_Data);
		//objFileInputStream = createObject("java", "java.io.StringBufferInputStream").init(mSVG_Data);
		objTransCoderInput = createObject("java", "org.apache.batik.transcoder.TranscoderInput").init(objFileInputStream);

		objFileOutputStream = objPC.getFusionContext().getResponse().getOutputStream();
		objTransCoderOutput = createObject("java", "org.apache.batik.transcoder.TranscoderOutput").init(objFileOutputStream);

		//objJpgTransCoder.addTranscodingHint(objJpgTransCoder.KEY_GAMMA, JavaCast("float", 1.1));	//gamma correction
		//objJpgTransCoder.addTranscodingHint(objJpgTransCoder.KEY_INDEXED, JavaCast("int", 500));
		objJpgTransCoder.transcode(objTransCoderInput, objTransCoderOutput);

		objFileOutputStream.flush();
		objFileOutputStream.close();
		/*END : Create Image Stream*/
	</cfscript>
</cffunction>

<cfif qryCountry.RecordCount gt 0>
	<cfquery name="qoqTotal" dbtype="query">
		SELECT Sum(Cnt) AS SumTotal FROM qryCountry
	</cfquery>

	<cfquery name="sort" dbtype="query">
		SELECT * FROM qryCountry
	</cfquery>

	<cfsavecontent variable="ctxSVG_Data">
		<cfoutput>
				<cfscript>
					x = 100; y = 150; rx = 170; ry = 200; ir = 0;
					w = 350;
					h = 350;
					d = 30;
					alpha = 45;
					beta = 0;
					r = h/2;

					intTotal = 0;
					if(qoqTotal.RecordCount and qoqTotal.SumTotal neq ''){
						intTotal = qoqTotal.SumTotal;
					}

					stuPathArc = StructNew();
					stuPathArc.StrokeColor = '##ffffff';
					stuPathArc.StrokeWidth = '1';


					Data = StructNew();
					pie = arrayNew(1);
					Data.n = sort.recordcount;
				</cfscript>

			<cfloop query="sort">
				<cfscript>
					Data.count = sort.currentrow;
					Data.a0 = (sort.currentrow == 1 ? 0 : Data.a0);
					Data.a1 = (sort.currentrow == 1 ? 0 : Data.a1);
					Data.da = 2 * pi();
					Data.p = min(Abs(Data.da) / Data.n, 0);
					Data.pa = Data.p * (Data.da < 0 ? -1 : 1) ;
					Data.k = intTotal ? (Data.da - Data.n * Data.pa) / intTotal : 0;
					Data.a0 = Data.a1;
					Data.v = sort.Cnt[Data.count];
					Data.a1 = Data.a0 + (Data.v > 0 ? Data.v * Data.k : 0) + Data.pa;
					Data.endAngle = Data.a1;
					Data.startAngle = Data.a0 ;

					// Derived Variables
					cs = cos(Data.startAngle); // cosinus of the start angle
					ss = sin(Data.startAngle); // sinus of the start angle
					ce = cos(Data.endAngle); // cosinus of the end angle
					se = sin(Data.endAngle); // sinus of the end angle
					rx = r * cos(beta); // x-radius
					ry = r * cos(alpha); // y-radius
					irx = ir * cos(beta); // x-radius (inner)
					iry = ir * cos(alpha); // y-radius (inner)
					dx = d * sin(beta); // distance between top and bottom in x
					dy = d * sin(alpha);
					end = Data.endAngle - 0.00001; // end angle

					temp = StructNew();
					StructInsert(temp, 'id', sort.id ,true);
					StructInsert(temp, 'right', rightside() ,true);
					StructInsert(temp, 'left', leftside() ,true);
					StructInsert(temp, 'top', topSlice() ,true);
					StructInsert(temp, 'inner', innerSlice() ,true);
					StructInsert(temp, 'outer', pieOuter(Data, rx - .5, ry - .5, h-325) ,true);
					StructInsert(temp, 'slice', slice() ,true);
					StructInsert(temp, 'color', arrPathColor[Data.count] ,true);
					StructInsert(temp, 'startAngle', Data.startAngle ,true);
					StructInsert(temp, 'endAngle', end ,true);
					ArrayAppend(pie, temp);

					public function curveTo(cx, cy, rx, ry, start, end, dx, dy) {
						result = ''; arcAngle = end - start;
						dFactor = (4 * (sqr(2) - 1) / 3) / (PI() / 2);
						if ((end > start) && (end - start > PI() / 2 + 0.0001)) {
							result = result & curveTo(x, y, rx, ry, start, start + (PI() / 2), dx, dy);
							result = result & curveTo(x, y, rx, ry, start + (PI() / 2), end, dx, dy);
							return result;
						}
						if ((end < start) && (start - end > PI() / 2 + 0.0001)) {
							result  = result & curveTo(x, y, rx, ry, start, start - (PI() / 2), dx, dy);
							result  = result & curveTo(x, y, rx, ry, start - (PI() / 2), end, dx, dy);
							return result;
						}
						return " C #x + (rx * cos(start)) -((rx * dFactor * arcAngle) * sin(start)) + dx#
						#y + (ry * sin(start)) + ((ry * dFactor * arcAngle) * cos(start)) + dy#
						#x + (rx * cos(end)) + ((rx * dFactor * arcAngle) * sin(end)) + dx#
						#y + (ry * sin(end)) - ((ry * dFactor * arcAngle) * cos(end)) + dy#
						#x + (rx * cos(end)) + dx#
						#y + (ry * sin(end)) + dy#";
					}

					public function topSlice(){
						top = 'M #x + (rx * cs)#, #y + (ry * ss)# ';
						top = top & curveTo(x, y, rx, ry, Data.startAngle, Data.endAngle, 0, 0);
						top = top & 'L #x + (irx * ce)#, #y + (iry * se)# ';
						top = top & curveTo(x, y, irx, iry, Data.endAngle, Data.startAngle, 0, 0);
						top = top & 'Z';
						return trim(top);
					}

					public function innerSlice(){
						inn = 'M #x + (irx * cs)# #y + (iry * ss)#';
						inn = inn & curveTo(x, y, irx, iry, Data.startAngle, Data.endAngle, 0, 0);
						inn = inn &' L #x + (irx * cos(Data.endAngle)) + dx# #y + (iry * sin(Data.endAngle)) + dy#';

						inn = inn & curveTo(x, y, irx, iry, Data.endAngle, Data.startAngle, dx, dy);
						inn = inn & ' Z';
						return trim(inn);
					}

					public function leftside(){
						side = 'M #x + (rx * cs)# #y + (ry * ss)# L #x + (rx * cs) + dx# #y + (ry * ss) + dy# L #x + (irx * cs) + dx# #y + (iry * ss) + dy#
						L #x + (irx * cs) + dx# #y + (iry * ss) + dy#
						L #x + (irx * cs)# #y + (iry * ss)# Z';
						return trim(side);
					}

					public function rightside(){
						side = 'M #x + (rx * ce)# #y + (ry * se)#
						L #x + (rx * ce) + dx# #y + (ry * se) + dy#
						L #x + (irx * ce) + dx# #y + (iry * se) + dy#
						L #x + (irx * ce)# #y + (iry * se)#
						Z';
						return trim(side);
					}

					public function slice(){
						angle = (Data.endAngle + Data.startAngle) / 2;
						offset = 21 * Data.n;
						deg2rad = (PI() * 2 / 360);
						t_x = Round(cos(angle) * offset  * cos(alpha * deg2rad));
						t_y = (Round(sin(angle) * offset * cos(alpha * deg2rad)));
						return trim((t_x - ((Data.n * Data.count) / 3)&','&t_y - Data.n));
					}

					function pieOuter(d, rx, ry, h ){
					 startAngle = (d.startAngle > PI() ? PI() : d.startAngle);
					 endAngle = (d.endAngle > PI() ? PI() : d.endAngle);

					    sx = rx*cos(startAngle);
						sy = ry*sin(startAngle);
						ex = rx*cos(endAngle);
						ey = ry*sin(endAngle);
						ret = "M #sx# #(h+sy)# A #rx# #ry# 0 0 1 #ex# #(h+ey)# L
						#ex# #ey# A #rx# #ry# 0 0 0 #sx# #sy# z";
						return trim(ret);
					}
				</cfscript>
			</cfloop>
			<svg width="700" height="700" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 700" version="1.1" xmlns:xlink="http://www.w3.org/1999/xlink">

				<g transform="translate(250,250)" class="slice">
					<cfloop  from="1" to="#arrayLen(pie)#" index="i">
						<cfif structKeyExists(url, 'id') and #url.id# EQ #pie[i].id#>
							<path class="left"
                                d="#pie[i].left#"
                                fill="<cfif i NEQ 1>#pie[i - 1].color#<cfelse>#pie[arrayLen(pie)].color#</cfif>"
							/>
							<path class="right"
                                d="#pie[i].right#"
                                fill="<cfif i NEQ arrayLen(pie)>#pie[i + 1].color#<cfelse>#pie[1].color#</cfif>"
							/>
						</cfif>
					</cfloop>
					<cfloop from="1" to="#arrayLen(pie)#" index="i">

					<g fill="#pie[i].color#" <cfif structKeyExists(url, 'id') and #url.id# EQ #pie[i].id#>transform="<!--- scale(.90) ---> translate(#pie[i].slice#)"</cfif>>
						<cfif structKeyExists(url, 'id') and #url.id# EQ #pie[i].id#>
							<path class="left"
							d="#pie[i].left#"
							/>
							<path class="right"
							d="#pie[i].right#"
							/>
						</cfif>
						<path class="innerSlice"
							d="#pie[i].inner#"
						/>
						<path class="outerSlice"
							d="#pie[i].outer#"
							transform="translate(100,150)"
						/>
						<path class="topSlice"
							d="#pie[i].top#"
							stroke="#stuPathArc.StrokeColor#"
							stroke-linejoin: round;
							stroke-width="#stuPathArc.StrokeWidth#"
						/>
					</g>
					</cfloop>
				</g>
				<cfloop query="sort">
				<g transform="translate(#w + 200#, #(sort.currentrow - 1) * 15 + 100#)" x="300" y="25" class="legend">
					<rect x="15" y="10" height="10" width="10" fill="#arrPathColor[sort.CurrentRow]#"></rect>
					<text y="20" x="30" fill="#arrPathColor[sort.CurrentRow]#" style="font-size:15px;">#CountryName# (#Round((sort.Cnt/intTotal)*100)#%)</text>
				</g>
				</cfloop>
			</svg>
		</cfoutput>
	</cfsavecontent>
</cfif>
<cfoutput>
<!--- <cfdocument overwrite="yes" format="pdf" name="genPDF" filename="\svg_pdf.pdf" pagetype="a4" margintop="1" marginbottom="1" marginleft="1" marginright="1">
<form name="form1" method="post">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<body>
<cfset imgsrc = #ToBase64(SVGtoPNG(ctxSVG_Data))#>
<!--- <img src="data:image/png;base64, #imgsrc#" alt="3D GRAPH" width="500" height="500" /> --->
   <!--- #ctxSVG_Data# --->
</body>
<input type="submit" id="frm_submit" name="frm_submit" value="PDF"><br>
</html>
</form>
</cfdocument>
<cfif structKeyExists(form, "frm_submit")>
<cfheader name="Content-Disposition" value="attachment;filename=svg_pdf.pdf">
<cfcontent type="application/pdf"
		file="#expandPath('.')#\svg_pdf.pdf">
</cfif> --->
<div align="center">
	<label>Countries Available</label>
		<table>
			<tr>
				<th>ID</th>
				<th>Country</th>
				<th>Count</th>
			</tr>
			<cfloop query="sort">
				<tr>
					<td>#id#</td>
					<td>#countryname#</td>
					<td>#cnt#</td>
				</tr>
			</cfloop>
		</table>
		<label>Input the ID of PIE to be highlighted</label>
		<form>
			<input type="text" name="id" value=""/><input type="Submit" value="Submit"/>
		</form>
		#ctxSVG_Data#
		<!--- <cfdump var="#pie#"> --->
</div>
</cfoutput>