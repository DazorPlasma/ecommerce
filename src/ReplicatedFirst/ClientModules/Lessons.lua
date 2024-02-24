--!strict

--// Services

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

--// Other Variables

type PageType = {
	Title: string?,
	Content: string,
}

local Lessons = {}
Lessons.Names = {} :: {string}
Lessons.Pages = {} :: {[number]: {PageType}}
local lessonInfo = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Aux"):WaitForChild("LessonInfo")

--// Main Code

Lessons.Names[1] = "Magazinul digital"
Lessons.Names[2] = "Bitcoin"

Lessons.Pages[1] = {
	{
		Title = "Ce este magazinul digital?",
		Content = "Un magazin digital este un site web ce vinde produse sau servicii prin internet. Un magazin digital are avantajul de a ajunge la mai mulți clienți, de a reduce costurile operaționale și de a oferi o experiență personalizată pentru fiecare cumpărător"
	},
	{
		Content = "aici poți să faci nuștuce"
	},
	{
		Content = "Hai să vedem cum poți folosi un astfel de magazin!"
	}
}


local openLessonTween1 = TweenService:Create(lessonInfo, TweenInfo.new(0.5), { TextTransparency = 0 })
local openLessonTween2 =
	TweenService:Create(lessonInfo:WaitForChild("UIStroke"), TweenInfo.new(0.5), { Transparency = 0 })
local closeLessonTween1 = TweenService:Create(lessonInfo, TweenInfo.new(0.8), { TextTransparency = 1 })
local closeLessonTween2 =
	TweenService:Create(lessonInfo:WaitForChild("UIStroke"), TweenInfo.new(0.8), { Transparency = 1 })

function Lessons.showLesson(lesson: number)
	lessonInfo.Text = `Lecția #{lesson}: {Lessons.Names[lesson]}`
	openLessonTween1:Play()
	openLessonTween2:Play()
	task.wait(3)
	closeLessonTween1:Play()
	closeLessonTween2:Play()
end

return Lessons