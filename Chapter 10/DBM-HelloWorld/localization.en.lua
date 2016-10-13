local L = DBM:GetModLocalization("MyFirstBossMod")

L:SetGeneralLocalization{
	name = "Hello, World with DBM"
}

L:SetOptionLocalization{
	WarnHelloWorld = "Show Hello, World announce",
	SpecWarnHelloWorld = "Show Hello, World special warning",
	TimerHelloWorld = "Show Hello, World timer"
}

L:SetTimerLocalization{
	TimerHelloWorld = "Hello, World"
}

L:SetWarningLocalization{
	WarnHelloWorld =  ">%s< said Hello, World",
	SpecWarnHelloWorld = "Special Warning"
}