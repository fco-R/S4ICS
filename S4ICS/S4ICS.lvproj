﻿<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="18008000">
	<Item Name="My Computer" Type="My Computer">
		<Property Name="NI.SortType" Type="Int">3</Property>
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="SubVI" Type="Folder">
			<Item Name="Check admin.vi" Type="VI" URL="../SubVI/Check admin.vi"/>
			<Item Name="Check id.vi" Type="VI" URL="../SubVI/Check id.vi"/>
			<Item Name="Check message.vi" Type="VI" URL="../SubVI/Check message.vi"/>
			<Item Name="Config file.vi" Type="VI" URL="../SubVI/Config file.vi"/>
			<Item Name="Get date.vi" Type="VI" URL="../SubVI/Get date.vi"/>
			<Item Name="Help communication.vi" Type="VI" URL="../SubVI/Help communication.vi"/>
			<Item Name="Help login.vi" Type="VI" URL="../SubVI/Help login.vi"/>
			<Item Name="Help setup.vi" Type="VI" URL="../SubVI/Help setup.vi"/>
			<Item Name="Input name.vi" Type="VI" URL="../SubVI/Input name.vi"/>
			<Item Name="Picture Rotation.vi" Type="VI" URL="../SubVI/Picture Rotation.vi"/>
			<Item Name="General Client.vi" Type="VI" URL="../SubVI/General Client.vi"/>
			<Item Name="General Server.vi" Type="VI" URL="../SubVI/General Server.vi"/>
			<Item Name="Send email.vi" Type="VI" URL="../SubVI/Send email.vi"/>
			<Item Name="Trivial reply example.vi" Type="VI" URL="../SubVI/Trivial reply example.vi"/>
			<Item Name="ZeroMQ Client.vi" Type="VI" URL="../SubVI/ZeroMQ Client.vi"/>
			<Item Name="String to number.vi" Type="VI" URL="../SubVI/String to number.vi"/>
			<Item Name="Write log to file.vi" Type="VI" URL="../SubVI/Write log to file.vi"/>
		</Item>
		<Item Name="Custom" Type="Folder">
			<Item Name="calw knob new.ctl" Type="VI" URL="../Custom/calw knob new.ctl"/>
			<Item Name="cal wheel.ctl" Type="VI" URL="../Custom/cal wheel.ctl"/>
			<Item Name="S4msg.ctl" Type="VI" URL="../Custom/S4msg.ctl"/>
			<Item Name="calw knob.ctl" Type="VI" URL="../Custom/calw knob.ctl"/>
			<Item Name="gmir knob.ctl" Type="VI" URL="../Custom/gmir knob.ctl"/>
			<Item Name="Server states Enum.ctl" Type="VI" URL="../Custom/Server states Enum.ctl"/>
			<Item Name="Luca transparent.png" Type="Document" URL="../Custom/Luca transparent.png"/>
			<Item Name="asel background.png" Type="Document" URL="../Custom/asel background.png"/>
			<Item Name="asel transparent.png" Type="Document" URL="../Custom/asel transparent.png"/>
			<Item Name="wpsel transparent.png" Type="Document" URL="../Custom/wpsel transparent.png"/>
			<Item Name="wprot ctl.ctl" Type="VI" URL="../Custom/wprot ctl.ctl"/>
			<Item Name="S4ICS icon.ico" Type="Document" URL="../Custom/S4ICS icon.ico"/>
		</Item>
		<Item Name="DMX-ETH" Type="Folder">
			<Item Name="Send batch.vi" Type="VI" URL="../DMX-ETH/Send batch.vi"/>
			<Item Name="Send instruction.vi" Type="VI" URL="../DMX-ETH/Send instruction.vi"/>
			<Item Name="Get status.vi" Type="VI" URL="../DMX-ETH/Get status.vi"/>
			<Item Name="Send batch otimizado.vi" Type="VI" URL="../DMX-ETH/Send batch otimizado.vi"/>
			<Item Name="Teste Send instruction.vi" Type="VI" URL="../DMX-ETH/Teste Send instruction.vi"/>
		</Item>
		<Item Name="CTest" Type="Folder">
			<Item Name="File open.vi" Type="VI" URL="../CTest/File open.vi"/>
			<Item Name="Write log.vi" Type="VI" URL="../CTest/Write log.vi"/>
			<Item Name="ReadLogFile.vi" Type="VI" URL="../CTest/ReadLogFile.vi"/>
			<Item Name="Send cmd S4ICS.vi" Type="VI" URL="../CTest/Send cmd S4ICS.vi"/>
			<Item Name="S4ICS Batch-Extract.vi" Type="VI" URL="../CTest/S4ICS Batch-Extract.vi"/>
			<Item Name="S4ICS Batch Command.vi" Type="VI" URL="../CTest/S4ICS Batch Command.vi"/>
		</Item>
		<Item Name="Test VIs" Type="Folder">
			<Item Name="ZeroMQ Command Generator.vi" Type="VI" URL="../SubVI/ZeroMQ Command Generator.vi"/>
			<Item Name="S4GUI Command Generator.vi" Type="VI" URL="../SubVI/S4GUI Command Generator.vi"/>
		</Item>
		<Item Name="S4ICS.vi" Type="VI" URL="../S4ICS.vi"/>
		<Item Name="ICS.lvclass" Type="LVClass" URL="../ICS/ICS.lvclass"/>
		<Item Name="TCP-Server.lvclass" Type="LVClass" URL="../TCP-Server/TCP-Server.lvclass"/>
		<Item Name="Messenger.lvclass" Type="LVClass" URL="../Messenger/Messenger.lvclass"/>
		<Item Name="StateManager.lvclass" Type="LVClass" URL="../StateManager/StateManager.lvclass"/>
		<Item Name="MotorSim.lvclass" Type="LVClass" URL="../MotorSim/MotorSim.lvclass"/>
		<Item Name="Motor.lvclass" Type="LVClass" URL="../Motor/Motor.lvclass"/>
		<Item Name="MotorManager.lvclass" Type="LVClass" URL="../MotorManager/MotorManager.lvclass"/>
		<Item Name="WPROT.lvclass" Type="LVClass" URL="../Motor/WPROT.lvclass"/>
		<Item Name="WPSEL.lvclass" Type="LVClass" URL="../Motor/WPSEL.lvclass"/>
		<Item Name="ASEL.lvclass" Type="LVClass" URL="../Motor/ASEL.lvclass"/>
		<Item Name="CALW.lvclass" Type="LVClass" URL="../Motor/CALW.lvclass"/>
		<Item Name="GMIR.lvclass" Type="LVClass" URL="../Motor/GMIR.lvclass"/>
		<Item Name="GFOC.lvclass" Type="LVClass" URL="../Motor/GFOC.lvclass"/>
		<Item Name="Calcula delay.vi" Type="VI" URL="../Desenvolvimento/Calcula delay.vi"/>
		<Item Name="MQTT Client.vi" Type="VI" URL="../SubVI/MQTT Client.vi"/>
		<Item Name="Send routine test.vi" Type="VI" URL="../SubVI/Send routine test.vi"/>
		<Item Name="InterComm.vi" Type="VI" URL="../InterComm.vi"/>
		<Item Name="0mqComm.vi" Type="VI" URL="../0mqComm.vi"/>
		<Item Name="Test Cyclic instructions.vi" Type="VI" URL="../SubVI/Test Cyclic instructions.vi"/>
		<Item Name="Help logger.vi" Type="VI" URL="../SubVI/Help logger.vi"/>
		<Item Name="SPARC4.cfg" Type="Document" URL="../SPARC4.cfg"/>
		<Item Name="S4config.xml" Type="Document" URL="../S4config.xml"/>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="Application Directory.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Application Directory.vi"/>
				<Item Name="BuildHelpPath.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/BuildHelpPath.vi"/>
				<Item Name="Check if File or Folder Exists.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/libraryn.llb/Check if File or Folder Exists.vi"/>
				<Item Name="Check Special Tags.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Check Special Tags.vi"/>
				<Item Name="Clear Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Clear Errors.vi"/>
				<Item Name="Convert property node font to graphics font.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Convert property node font to graphics font.vi"/>
				<Item Name="Details Display Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Details Display Dialog.vi"/>
				<Item Name="DialogType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogType.ctl"/>
				<Item Name="DialogTypeEnum.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogTypeEnum.ctl"/>
				<Item Name="Error Cluster From Error Code.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Cluster From Error Code.vi"/>
				<Item Name="Error Code Database.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Code Database.vi"/>
				<Item Name="ErrWarn.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/ErrWarn.ctl"/>
				<Item Name="eventvkey.ctl" Type="VI" URL="/&lt;vilib&gt;/event_ctls.llb/eventvkey.ctl"/>
				<Item Name="Find Tag.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Find Tag.vi"/>
				<Item Name="Format Message String.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Format Message String.vi"/>
				<Item Name="General Error Handler Core CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler Core CORE.vi"/>
				<Item Name="General Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler.vi"/>
				<Item Name="Get String Text Bounds.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Get String Text Bounds.vi"/>
				<Item Name="Get Text Rect.vi" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/Get Text Rect.vi"/>
				<Item Name="GetHelpDir.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetHelpDir.vi"/>
				<Item Name="GetRTHostConnectedProp.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetRTHostConnectedProp.vi"/>
				<Item Name="Longest Line Length in Pixels.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Longest Line Length in Pixels.vi"/>
				<Item Name="LVBoundsTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVBoundsTypeDef.ctl"/>
				<Item Name="LVRectTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVRectTypeDef.ctl"/>
				<Item Name="MD5Checksum core.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/MD5Checksum.llb/MD5Checksum core.vi"/>
				<Item Name="MD5Checksum format message-digest.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/MD5Checksum.llb/MD5Checksum format message-digest.vi"/>
				<Item Name="MD5Checksum pad.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/MD5Checksum.llb/MD5Checksum pad.vi"/>
				<Item Name="MD5Checksum string.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/MD5Checksum.llb/MD5Checksum string.vi"/>
				<Item Name="NI_FileType.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/lvfile.llb/NI_FileType.lvlib"/>
				<Item Name="NI_PackedLibraryUtility.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/LVLibp/NI_PackedLibraryUtility.lvlib"/>
				<Item Name="Not Found Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Not Found Dialog.vi"/>
				<Item Name="Search and Replace Pattern.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Search and Replace Pattern.vi"/>
				<Item Name="Set Bold Text.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set Bold Text.vi"/>
				<Item Name="Set String Value.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set String Value.vi"/>
				<Item Name="Simple Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Simple Error Handler.vi"/>
				<Item Name="TagReturnType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/TagReturnType.ctl"/>
				<Item Name="Three Button Dialog CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog CORE.vi"/>
				<Item Name="Three Button Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog.vi"/>
				<Item Name="Trim Whitespace.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Trim Whitespace.vi"/>
				<Item Name="whitespace.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/whitespace.ctl"/>
				<Item Name="LabVIEWSMTPClient.lvlib" Type="Library" URL="/&lt;vilib&gt;/smtpClient/LabVIEWSMTPClient.lvlib"/>
				<Item Name="Path To Command Line String.vi" Type="VI" URL="/&lt;vilib&gt;/AdvancedString/Path To Command Line String.vi"/>
				<Item Name="PathToUNIXPathString.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/CFURL.llb/PathToUNIXPathString.vi"/>
				<Item Name="compatCalcOffset.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatCalcOffset.vi"/>
				<Item Name="compatOpenFileOperation.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatOpenFileOperation.vi"/>
				<Item Name="compatFileDialog.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatFileDialog.vi"/>
				<Item Name="Open_Create_Replace File.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/Open_Create_Replace File.vi"/>
				<Item Name="Write to XML File(string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/Write to XML File(string).vi"/>
				<Item Name="Write to XML File(array).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/Write to XML File(array).vi"/>
				<Item Name="Write to XML File.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/xml.llb/Write to XML File.vi"/>
				<Item Name="Space Constant.vi" Type="VI" URL="/&lt;vilib&gt;/dlg_ctls.llb/Space Constant.vi"/>
				<Item Name="FixBadRect.vi" Type="VI" URL="/&lt;vilib&gt;/picture/pictutil.llb/FixBadRect.vi"/>
				<Item Name="imagedata.ctl" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/imagedata.ctl"/>
				<Item Name="Draw Flattened Pixmap.vi" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/Draw Flattened Pixmap.vi"/>
				<Item Name="Bit-array To Byte-array.vi" Type="VI" URL="/&lt;vilib&gt;/picture/pictutil.llb/Bit-array To Byte-array.vi"/>
				<Item Name="Create Mask By Alpha.vi" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/Create Mask By Alpha.vi"/>
				<Item Name="Directory of Top Level VI.vi" Type="VI" URL="/&lt;vilib&gt;/picture/jpeg.llb/Directory of Top Level VI.vi"/>
				<Item Name="Check Path.vi" Type="VI" URL="/&lt;vilib&gt;/picture/jpeg.llb/Check Path.vi"/>
				<Item Name="Read PNG File.vi" Type="VI" URL="/&lt;vilib&gt;/picture/png.llb/Read PNG File.vi"/>
				<Item Name="Unflatten Pixmap.vi" Type="VI" URL="/&lt;vilib&gt;/picture/pixmap.llb/Unflatten Pixmap.vi"/>
				<Item Name="Flatten Pixmap.vi" Type="VI" URL="/&lt;vilib&gt;/picture/pixmap.llb/Flatten Pixmap.vi"/>
				<Item Name="Coerce Bad Rect.vi" Type="VI" URL="/&lt;vilib&gt;/picture/pictutil.llb/Coerce Bad Rect.vi"/>
				<Item Name="Get Image Subset.vi" Type="VI" URL="/&lt;vilib&gt;/picture/pictutil.llb/Get Image Subset.vi"/>
				<Item Name="Create Mask.vi" Type="VI" URL="/&lt;vilib&gt;/picture/pictutil.llb/Create Mask.vi"/>
				<Item Name="Beep.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/system.llb/Beep.vi"/>
				<Item Name="MQTT Client.lvlib" Type="Library" URL="/&lt;vilib&gt;/LabVIEW Open Source Project/MQTT Client/MQTT Client.lvlib"/>
				<Item Name="MQTT Base.lvlib" Type="Library" URL="/&lt;vilib&gt;/LabVIEW Open Source Project/MQTT Connection/MQTT_Base/MQTT Base.lvlib"/>
				<Item Name="Connection.TCP_GOSPL.lvlib" Type="Library" URL="/&lt;vilib&gt;/LabVIEW Open Source Project/Connection/Connection.TCP/Connection.TCP_GOSPL.lvlib"/>
				<Item Name="MQTT_Control_Packets.lvlib" Type="Library" URL="/&lt;vilib&gt;/LabVIEW Open Source Project/MQTT Control Packets/Control Packets/MQTT_Control_Packets.lvlib"/>
				<Item Name="OpenSerializer.lvlib" Type="Library" URL="/&lt;vilib&gt;/LabVIEW Open Source Project/OpenSerializer/OpenSerializer.lvlib"/>
				<Item Name="VariantType.lvlib" Type="Library" URL="/&lt;vilib&gt;/Utility/VariantDataType/VariantType.lvlib"/>
				<Item Name="Connection_GOSPL.lvlib" Type="Library" URL="/&lt;vilib&gt;/LabVIEW Open Source Project/Connection/Connection/Connection_GOSPL.lvlib"/>
				<Item Name="Default MQTT Packet (Empty).vi" Type="VI" URL="/&lt;vilib&gt;/LabVIEW Open Source Project/MQTT Control Packets/Control Packets/ControlPacket/Default MQTT Packet (Empty).vi"/>
				<Item Name="Get Semaphore Status.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Get Semaphore Status.vi"/>
				<Item Name="Semaphore RefNum" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Semaphore RefNum"/>
				<Item Name="Semaphore Refnum Core.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Semaphore Refnum Core.ctl"/>
				<Item Name="RemoveNamedSemaphorePrefix.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/RemoveNamedSemaphorePrefix.vi"/>
				<Item Name="GetNamedSemaphorePrefix.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/GetNamedSemaphorePrefix.vi"/>
				<Item Name="Acquire Semaphore.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Acquire Semaphore.vi"/>
				<Item Name="Release Semaphore.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Release Semaphore.vi"/>
				<Item Name="Not A Semaphore.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Not A Semaphore.vi"/>
				<Item Name="Obtain Semaphore Reference.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Obtain Semaphore Reference.vi"/>
				<Item Name="AddNamedSemaphorePrefix.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/AddNamedSemaphorePrefix.vi"/>
				<Item Name="Validate Semaphore Size.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Validate Semaphore Size.vi"/>
				<Item Name="OpenVariant.lvlib" Type="Library" URL="/&lt;vilib&gt;/LabVIEW Open Source Project/Data Manipulation/Variant/OpenVariant.lvlib"/>
				<Item Name="OpenDescriptor.lvlib" Type="Library" URL="/&lt;vilib&gt;/LabVIEW Open Source Project/Data Manipulation/TypeDescriptor/OpenDescriptor.lvlib"/>
				<Item Name="Connection.Queue_GOSPL.lvlib" Type="Library" URL="/&lt;vilib&gt;/LabVIEW Open Source Project/Connection/Connection.LocalQueue/Connection.Queue_GOSPL.lvlib"/>
				<Item Name="RandomStringGenerator.lvclass" Type="LVClass" URL="/&lt;vilib&gt;/LabVIEW Open Source Project/Unicity/RandomStringGenerator/RandomStringGenerator.lvclass"/>
				<Item Name="zeromq.lvlib" Type="Library" URL="/&lt;vilib&gt;/addons/zeromq/zeromq.lvlib"/>
				<Item Name="NI_AALBase.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AALBase.lvlib"/>
			</Item>
			<Item Name="Message Queue.lvlib" Type="Library" URL="../Message Queue/Message Queue.lvlib"/>
			<Item Name="lvanlys.dll" Type="Document" URL="/&lt;resource&gt;/lvanlys.dll"/>
		</Item>
		<Item Name="Build Specifications" Type="Build">
			<Item Name="S4ICS build 20240213" Type="EXE">
				<Property Name="App_copyErrors" Type="Bool">true</Property>
				<Property Name="App_INI_aliasGUID" Type="Str">{0E77BE8C-6CC1-4AD8-A115-C44D2422845F}</Property>
				<Property Name="App_INI_GUID" Type="Str">{9A21B7FE-DF7F-4F6A-82EE-2AF25672A766}</Property>
				<Property Name="App_serverConfig.httpPort" Type="Int">8002</Property>
				<Property Name="Bld_autoIncrement" Type="Bool">true</Property>
				<Property Name="Bld_buildCacheID" Type="Str">{EBC7F703-420D-4272-AD89-F237AE05B474}</Property>
				<Property Name="Bld_buildSpecName" Type="Str">S4ICS build 20240213</Property>
				<Property Name="Bld_excludeInlineSubVIs" Type="Bool">true</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_localDestDir" Type="Path">../builds/NI_AB_PROJECTNAME/S4ICS build 20240213</Property>
				<Property Name="Bld_localDestDirType" Type="Str">relativeToCommon</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Bld_previewCacheID" Type="Str">{71A886A9-3310-4D19-BA46-2B039ECCA2C0}</Property>
				<Property Name="Bld_version.build" Type="Int">61</Property>
				<Property Name="Bld_version.major" Type="Int">1</Property>
				<Property Name="Destination[0].destName" Type="Str">S4ICS.exe</Property>
				<Property Name="Destination[0].path" Type="Path">../builds/NI_AB_PROJECTNAME/S4ICS build 20240213/S4ICS.exe</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">../builds/NI_AB_PROJECTNAME/S4ICS build 20240213/Custom</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Exe_cmdLineArgs" Type="Bool">true</Property>
				<Property Name="Exe_iconItemID" Type="Ref">/My Computer/Custom/S4ICS icon.ico</Property>
				<Property Name="Source[0].itemID" Type="Str">{4471420F-20E0-46B9-8758-145B1B30BE8D}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/My Computer/S4ICS.vi</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">VI</Property>
				<Property Name="Source[10].destinationIndex" Type="Int">1</Property>
				<Property Name="Source[10].itemID" Type="Ref">/My Computer/CTest/S4ICS Batch-Extract.vi</Property>
				<Property Name="Source[10].type" Type="Str">VI</Property>
				<Property Name="Source[11].destinationIndex" Type="Int">1</Property>
				<Property Name="Source[11].itemID" Type="Ref">/My Computer/CTest/S4ICS Batch Command.vi</Property>
				<Property Name="Source[11].type" Type="Str">VI</Property>
				<Property Name="Source[2].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[2].itemID" Type="Ref">/My Computer/Custom/Luca transparent.png</Property>
				<Property Name="Source[3].Container.applyDestination" Type="Bool">true</Property>
				<Property Name="Source[3].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[3].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[3].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[3].itemID" Type="Ref">/My Computer/Custom</Property>
				<Property Name="Source[3].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[3].type" Type="Str">Container</Property>
				<Property Name="Source[4].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[4].itemID" Type="Ref">/My Computer/Custom/wprot ctl.ctl</Property>
				<Property Name="Source[4].type" Type="Str">VI</Property>
				<Property Name="Source[5].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[5].itemID" Type="Ref">/My Computer/Custom/gmir knob.ctl</Property>
				<Property Name="Source[5].type" Type="Str">VI</Property>
				<Property Name="Source[6].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[6].itemID" Type="Ref">/My Computer/Custom/calw knob.ctl</Property>
				<Property Name="Source[6].type" Type="Str">VI</Property>
				<Property Name="Source[7].Container.applyDestination" Type="Bool">true</Property>
				<Property Name="Source[7].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[7].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[7].itemID" Type="Ref">/My Computer/SubVI</Property>
				<Property Name="Source[7].type" Type="Str">Container</Property>
				<Property Name="Source[8].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[8].itemID" Type="Ref">/My Computer/InterComm.vi</Property>
				<Property Name="Source[8].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[8].type" Type="Str">VI</Property>
				<Property Name="Source[9].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[9].itemID" Type="Ref">/My Computer/Test VIs/S4GUI Command Generator.vi</Property>
				<Property Name="Source[9].type" Type="Str">VI</Property>
				<Property Name="SourceCount" Type="Int">12</Property>
				<Property Name="TgtF_companyName" Type="Str">Laboratório Nacional de Astrofísica</Property>
				<Property Name="TgtF_fileDescription" Type="Str">S4ICS build 20240213</Property>
				<Property Name="TgtF_internalName" Type="Str">S4ICS build 20240213</Property>
				<Property Name="TgtF_legalCopyright" Type="Str">Copyright © 2021 Laboratório Nacional de Astrofísica</Property>
				<Property Name="TgtF_productName" Type="Str">S4ICS build 20240213</Property>
				<Property Name="TgtF_targetfileGUID" Type="Str">{68B4D8A4-BD38-4F86-84E8-A86E9AA28C9A}</Property>
				<Property Name="TgtF_targetfileName" Type="Str">S4ICS.exe</Property>
				<Property Name="TgtF_versionIndependent" Type="Bool">true</Property>
			</Item>
			<Item Name="S4ICS build 20240423" Type="EXE">
				<Property Name="App_copyErrors" Type="Bool">true</Property>
				<Property Name="App_INI_aliasGUID" Type="Str">{8A235C71-A2E5-46CC-8DB6-D621AFCBA7AA}</Property>
				<Property Name="App_INI_GUID" Type="Str">{0BF92381-9388-4EB7-88E5-3A92E4C36B84}</Property>
				<Property Name="App_serverConfig.httpPort" Type="Int">8002</Property>
				<Property Name="Bld_autoIncrement" Type="Bool">true</Property>
				<Property Name="Bld_buildCacheID" Type="Str">{E3943F2A-19E3-4A91-9579-23B2032436B7}</Property>
				<Property Name="Bld_buildSpecName" Type="Str">S4ICS build 20240423</Property>
				<Property Name="Bld_excludeInlineSubVIs" Type="Bool">true</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_localDestDir" Type="Path">../builds/NI_AB_PROJECTNAME/S4ICS build 20240423</Property>
				<Property Name="Bld_localDestDirType" Type="Str">relativeToCommon</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Bld_previewCacheID" Type="Str">{E0A8D97A-7117-41A3-BD95-7AE4A6146B70}</Property>
				<Property Name="Bld_version.build" Type="Int">69</Property>
				<Property Name="Bld_version.major" Type="Int">1</Property>
				<Property Name="Destination[0].destName" Type="Str">S4ICS.exe</Property>
				<Property Name="Destination[0].path" Type="Path">../builds/NI_AB_PROJECTNAME/S4ICS build 20240423/S4ICS.exe</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">../builds/NI_AB_PROJECTNAME/S4ICS build 20240423/Custom</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Exe_cmdLineArgs" Type="Bool">true</Property>
				<Property Name="Exe_iconItemID" Type="Ref">/My Computer/Custom/S4ICS icon.ico</Property>
				<Property Name="Source[0].itemID" Type="Str">{28F6F10A-E30D-4A0F-878B-4E24579A159B}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/My Computer/S4ICS.vi</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">VI</Property>
				<Property Name="Source[10].destinationIndex" Type="Int">1</Property>
				<Property Name="Source[10].itemID" Type="Ref">/My Computer/CTest/S4ICS Batch-Extract.vi</Property>
				<Property Name="Source[10].type" Type="Str">VI</Property>
				<Property Name="Source[11].destinationIndex" Type="Int">1</Property>
				<Property Name="Source[11].itemID" Type="Ref">/My Computer/CTest/S4ICS Batch Command.vi</Property>
				<Property Name="Source[11].type" Type="Str">VI</Property>
				<Property Name="Source[12].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[12].itemID" Type="Ref">/My Computer/Test VIs/ZeroMQ Command Generator.vi</Property>
				<Property Name="Source[12].type" Type="Str">VI</Property>
				<Property Name="Source[13].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[13].itemID" Type="Ref">/My Computer/0mqComm.vi</Property>
				<Property Name="Source[13].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[13].type" Type="Str">VI</Property>
				<Property Name="Source[14].Container.applyDestination" Type="Bool">true</Property>
				<Property Name="Source[14].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[14].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[14].destinationIndex" Type="Int">1</Property>
				<Property Name="Source[14].itemID" Type="Ref">/My Computer/Test VIs</Property>
				<Property Name="Source[14].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[14].type" Type="Str">Container</Property>
				<Property Name="Source[15].itemID" Type="Ref">/My Computer/SPARC4.cfg</Property>
				<Property Name="Source[15].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[16].itemID" Type="Ref">/My Computer/S4config.xml</Property>
				<Property Name="Source[16].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[2].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[2].itemID" Type="Ref">/My Computer/Custom/Luca transparent.png</Property>
				<Property Name="Source[3].Container.applyDestination" Type="Bool">true</Property>
				<Property Name="Source[3].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[3].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[3].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[3].itemID" Type="Ref">/My Computer/Custom</Property>
				<Property Name="Source[3].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[3].type" Type="Str">Container</Property>
				<Property Name="Source[4].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[4].itemID" Type="Ref">/My Computer/Custom/wprot ctl.ctl</Property>
				<Property Name="Source[4].type" Type="Str">VI</Property>
				<Property Name="Source[5].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[5].itemID" Type="Ref">/My Computer/Custom/gmir knob.ctl</Property>
				<Property Name="Source[5].type" Type="Str">VI</Property>
				<Property Name="Source[6].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[6].itemID" Type="Ref">/My Computer/Custom/calw knob.ctl</Property>
				<Property Name="Source[6].type" Type="Str">VI</Property>
				<Property Name="Source[7].Container.applyDestination" Type="Bool">true</Property>
				<Property Name="Source[7].Container.depDestIndex" Type="Int">0</Property>
				<Property Name="Source[7].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[7].itemID" Type="Ref">/My Computer/SubVI</Property>
				<Property Name="Source[7].type" Type="Str">Container</Property>
				<Property Name="Source[8].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[8].itemID" Type="Ref">/My Computer/InterComm.vi</Property>
				<Property Name="Source[8].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[8].type" Type="Str">VI</Property>
				<Property Name="Source[9].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[9].itemID" Type="Ref">/My Computer/Test VIs/S4GUI Command Generator.vi</Property>
				<Property Name="Source[9].type" Type="Str">VI</Property>
				<Property Name="SourceCount" Type="Int">17</Property>
				<Property Name="TgtF_companyName" Type="Str">Laboratório Nacional de Astrofísica</Property>
				<Property Name="TgtF_fileDescription" Type="Str">S4ICS build 20240213</Property>
				<Property Name="TgtF_internalName" Type="Str">S4ICS build 20240213</Property>
				<Property Name="TgtF_legalCopyright" Type="Str">Copyright © 2021 Laboratório Nacional de Astrofísica</Property>
				<Property Name="TgtF_productName" Type="Str">S4ICS build 20240213</Property>
				<Property Name="TgtF_targetfileGUID" Type="Str">{3CC289FF-9C02-4BEE-854D-9A5B098595F1}</Property>
				<Property Name="TgtF_targetfileName" Type="Str">S4ICS.exe</Property>
				<Property Name="TgtF_versionIndependent" Type="Bool">true</Property>
			</Item>
		</Item>
	</Item>
</Project>