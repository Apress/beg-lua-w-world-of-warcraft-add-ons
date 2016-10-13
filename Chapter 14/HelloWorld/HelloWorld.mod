<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <UiMod name="HelloWorld" version="1.2.1" autoenabled="true">
      <Description text="A Hello, World AddOn"/>
      <Author name="You!"/>
      <Files>
         <File name="HelloWorld.lua"/>
      </Files>
	<OnInitialize>
		<CallFunction name="HelloWorld_Initialize"/>
	</OnInitialize>
   </UiMod>
</ModuleFile>