////////////////////////////////////////////////////////////////////////////////
// Общая форма текстовой клавиатуры Wallet.
// Ввод комментариев и произвольного текста без системной клавиатуры.
// Набор символов обрабатывается в JS (без пересборки HTML на каждый символ).
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаголовокКлавиатуры = "Текст";
	МаксДлина = 100;
	Раскладка = "ru";
	РегистрВерхний = Ложь;
	ТекстВвода = "";
	
	Если Параметры.Свойство("Заголовок") И ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		
		ЗаголовокКлавиатуры = Параметры.Заголовок;
		
	КонецЕсли;
	
	Если Параметры.Свойство("Текст") Тогда
		
		ТекстВвода = Строка(Параметры.Текст);
		
	КонецЕсли;
	
	Если Параметры.Свойство("МаксДлина") И Параметры.МаксДлина > 0 Тогда
		
		МаксДлина = Параметры.МаксДлина;
		
	КонецЕсли;
	
	Если СтрДлина(ТекстВвода) > МаксДлина Тогда
		
		ТекстВвода = Лев(ТекстВвода, МаксДлина);
		
	КонецЕсли;
	
	Заголовок = ЗаголовокКлавиатуры;
	ОбновитьHTMLНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	КомандаПриложения = ИзвлечьКомандуИзСсылки(ДанныеСобытия.Href);
	
	Если Не ЗначениеЗаполнено(КомандаПриложения) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ОбработатьКомандуHTML(КомандаПриложения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьКомандуHTML(КомандаПриложения)
	
	Если КомандаПриложения = "noop" Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если КомандаПриложения = "back" Или КомандаПриложения = "cancel" Тогда
		
		Закрыть(Неопределено);
		Возврат;
		
	КонецЕсли;
	
	Если КомандаПриложения = "done" Или СтрНачинаетсяС(КомандаПриложения, "done:") Тогда
		
		Если СтрНачинаетсяС(КомандаПриложения, "done:") Тогда
			
			ТекстВвода = ТекстИзКодовСимволов(Сред(КомандаПриложения, СтрДлина("done:") + 1));
			
		КонецЕсли;
		
		Закрыть(ТекстВвода);
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ТекстИзКодовСимволов(Знач СтрокаКодов)
	
	Если Не ЗначениеЗаполнено(СтрокаКодов) Тогда
		
		Возврат "";
		
	КонецЕсли;
	
	Части = СтрРазделить(СтрокаКодов, "-", Ложь);
	Буфер = Новый Массив;
	
	Для Каждого Часть Из Части Цикл
		
		КодСтрокой = СокрЛП(Часть);
		
		Если Не ЗначениеЗаполнено(КодСтрокой) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Буфер.Добавить(Символ(Число(КодСтрокой)));
		
	КонецЦикла;
	
	Возврат СтрСоединить(Буфер, "");
	
КонецФункции

&НаСервере
Процедура ОбновитьHTMLНаСервере()
	
	ТекстHTML = СобратьHTMLКлавиатуры();
	
КонецПроцедуры

&НаСервере
Функция СобратьHTMLКлавиатуры()
	
	Длина = СтрДлина(ТекстВвода);
	Плейсхолдер = ПустаяСтрока(ТекстВвода);
	ТекстЭкрана = ?(Плейсхолдер, "Начните ввод…", ТекстВвода);
	КлассТекста = ?(Плейсхолдер, "preview placeholder", "preview");
	
	Строки = Новый Массив;
	Строки.Добавить("<!DOCTYPE html><html lang=""ru""><head><meta charset=""utf-8"">");
	Строки.Добавить("<meta name=""viewport"" content=""width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"">");
	Строки.Добавить("<style>" + СтилиКлавиатуры() + "</style></head><body>");
	Строки.Добавить("<div class=""sheet"">");
	Строки.Добавить("<div class=""top"">");
	Строки.Добавить("<a class=""icon-btn"" href=""app:noop"" data-cmd=""back"">" + SVGСтрелкаНазад() + "</a>");
	Строки.Добавить("<div class=""title"">" + ЭкранироватьHTML(ЗаголовокКлавиатуры) + "</div>");
	Строки.Добавить("<span class=""icon-btn ghost""></span></div>");
	
	Строки.Добавить("<div class=""field"">");
	Строки.Добавить("<div id=""preview"" class=""" + КлассТекста + """>" + ЭкранироватьHTML(ТекстЭкрана) + "</div>");
	Строки.Добавить("<div class=""meta""><a class=""clear-link"" href=""app:noop"" data-cmd=""clear"">Очистить</a>");
	Строки.Добавить("<span id=""counter"" class=""counter"">" + Формат(Длина, "ЧН=0; ЧГ=") + "/"
		+ Формат(МаксДлина, "ЧН=0; ЧГ=") + "</span></div></div>");
	
	Строки.Добавить("<div class=""pad"" id=""pad-ru"">");
	ДобавитьРядыБукв(Строки, "ru");
	Строки.Добавить("</div>");
	
	Строки.Добавить("<div class=""pad"" id=""pad-en"" hidden>");
	ДобавитьРядыБукв(Строки, "en");
	Строки.Добавить("</div>");
	
	Строки.Добавить("<div class=""pad"" id=""pad-num"" hidden>");
	ДобавитьРядыЦифр(Строки);
	Строки.Добавить("</div>");
	
	Строки.Добавить("<div class=""actions"">");
	Строки.Добавить("<a class=""done"" href=""app:noop"" data-cmd=""done"">Готово</a>");
	Строки.Добавить("</div></div>");
	Строки.Добавить("<script>" + СкриптКлавиатуры() + "</script>");
	Строки.Добавить("</body></html>");
	
	Возврат СтрСоединить(Строки, Символы.ПС);
	
КонецФункции

&НаСервере
Процедура ДобавитьРядыБукв(Строки, КодРаскладки)
	
	Если КодРаскладки = "en" Тогда
		
		Ряд1 = "qwertyuiop";
		Ряд2 = "asdfghjkl";
		Ряд3 = "zxcvbnm";
		МеткаРаскладки = "РУ";
		СледРаскладка = "ru";
		
	Иначе
		
		Ряд1 = "йцукенгшщзх";
		Ряд2 = "фывапролджэ";
		Ряд3 = "ячсмитьбю";
		МеткаРаскладки = "EN";
		СледРаскладка = "en";
		
	КонецЕсли;
	
	ДобавитьРядСимволов(Строки, Ряд1);
	ДобавитьРядСимволов(Строки, Ряд2);
	Строки.Добавить("<div class=""row"">");
	Строки.Добавить(HTMLКлавишаКоманда("⇧", "shift", "mod shift-key"));
	ДобавитьСимволыРяда(Строки, Ряд3);
	Строки.Добавить(HTMLКлавишаКоманда(SVGBackspace(), "backspace", "mod"));
	Строки.Добавить("</div>");
	Строки.Добавить("<div class=""row"">");
	Строки.Добавить(HTMLКлавишаКоманда("123", "layout", "mod", "num"));
	Строки.Добавить(HTMLКлавишаКоманда(МеткаРаскладки, "layout", "mod", СледРаскладка));
	Строки.Добавить(HTMLКлавишаКоманда("␣", "space", "space"));
	Строки.Добавить(HTMLКлавишаСимвол(","));
	Строки.Добавить(HTMLКлавишаСимвол("."));
	Строки.Добавить("</div>");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьРядыЦифр(Строки)
	
	ДобавитьРядСимволов(Строки, "1234567890");
	ДобавитьРядСимволов(Строки, "-/:;()$@&");
	ДобавитьРядСимволов(Строки, ".,?!'""");
	Строки.Добавить("<div class=""row"">");
	Строки.Добавить(HTMLКлавишаКоманда("АБВ", "layout", "mod", "ru"));
	Строки.Добавить(HTMLКлавишаКоманда("␣", "space", "space"));
	Строки.Добавить(HTMLКлавишаКоманда(SVGBackspace(), "backspace", "mod"));
	Строки.Добавить("</div>");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьРядСимволов(Строки, СимволыРяда)
	
	Строки.Добавить("<div class=""row"">");
	ДобавитьСимволыРяда(Строки, СимволыРяда);
	Строки.Добавить("</div>");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСимволыРяда(Строки, СимволыРяда)
	
	Для Номер = 1 По СтрДлина(СимволыРяда) Цикл
		
		Строки.Добавить(HTMLКлавишаСимвол(Сред(СимволыРяда, Номер, 1)));
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция HTMLКлавишаСимвол(СимволТекста)
	
	Возврат "<a class=""key"" href=""app:noop"" data-ch=""" + ЭкранироватьАтрибут(СимволТекста) + """>"
		+ ЭкранироватьHTML(СимволТекста) + "</a>";
	
КонецФункции

&НаСервере
Функция HTMLКлавишаКоманда(Содержимое, Команда, ДопКласс, РаскладкаКнопки = "")
	
	Класс = "key";
	
	Если ЗначениеЗаполнено(ДопКласс) Тогда
		
		Класс = Класс + " " + ДопКласс;
		
	КонецЕсли;
	
	АтрибутРаскладки = "";
	
	Если ЗначениеЗаполнено(РаскладкаКнопки) Тогда
		
		АтрибутРаскладки = " data-layout=""" + РаскладкаКнопки + """";
		
	КонецЕсли;
	
	Возврат "<a class=""" + Класс + """ href=""app:noop"" data-cmd=""" + Команда + """"
		+ АтрибутРаскладки + ">" + Содержимое + "</a>";
	
КонецФункции

&НаСервере
Функция СкриптКлавиатуры()
	
	ИнитТекст = ТекстКакFromCharCode(ТекстВвода);
	
	Возврат "(function(){"
		+ "var text=" + ИнитТекст + ";"
		+ "var maxLen=" + Формат(МаксДлина, "ЧН=0; ЧГ=") + ";"
		+ "var upper=false;"
		+ "var layout='ru';"
		+ "var bsDelay=null,bsRepeat=null,armed=false;"
		+ "function pack(s){var a=[];for(var i=0;i<s.length;i++)a.push(s.charCodeAt(i));return a.join('-');}"
		+ "function updateUI(){"
		+ "var p=document.getElementById('preview'),c=document.getElementById('counter');"
		+ "if(!p||!c)return;"
		+ "if(!text.length){p.className='preview placeholder';p.textContent='Начните ввод…';}"
		+ "else{p.className='preview';p.textContent=text;}"
		+ "c.textContent=text.length+'/'+maxLen;}"
		+ "function updateShift(){"
		+ "var keys=document.querySelectorAll('.pad:not([hidden]) a[data-ch]');"
		+ "for(var i=0;i<keys.length;i++){"
		+ "var ch=keys[i].getAttribute('data-ch');"
		+ "if(!ch||ch.length!==1)continue;"
		+ "var code=ch.charCodeAt(0);"
		+ "if((code>=97&&code<=122)||(code>=1072&&code<=1103)||code===1105)"
		+ "{keys[i].textContent=upper?ch.toUpperCase():ch.toLowerCase();}}"
		+ "var sk=document.querySelectorAll('.shift-key');"
		+ "for(var j=0;j<sk.length;j++){if(upper)sk[j].classList.add('active');else sk[j].classList.remove('active');}}"
		+ "function showPad(name){"
		+ "layout=name;"
		+ "var ids=['ru','en','num'];"
		+ "for(var i=0;i<ids.length;i++){"
		+ "var el=document.getElementById('pad-'+ids[i]);"
		+ "if(el){if(ids[i]===name)el.removeAttribute('hidden');else el.setAttribute('hidden','');}}"
		+ "if(name==='num'){upper=false;}"
		+ "updateShift();}"
		+ "function addChar(ch){"
		+ "if(text.length>=maxLen)return;"
		+ "if(upper&&layout!=='num'&&ch.length===1)ch=ch.toUpperCase();"
		+ "text+=ch;"
		+ "if(upper&&layout!=='num'){upper=false;updateShift();}"
		+ "updateUI();}"
		+ "function doBackspace(){if(text.length){text=text.slice(0,-1);updateUI();}}"
		+ "function stopRepeat(){if(bsDelay){clearTimeout(bsDelay);bsDelay=null;}if(bsRepeat){clearInterval(bsRepeat);bsRepeat=null;}}"
		+ "function findKey(t){while(t&&t!==document){if(t.getAttribute&&(t.getAttribute('data-ch')||t.getAttribute('data-cmd')))return t;t=t.parentNode;}return null;}"
		+ "function onDown(e){"
		+ "var key=findKey(e.target);if(!key)return;"
		+ "if(e.cancelable)e.preventDefault();"
		+ "e.stopPropagation();"
		+ "if(armed)return;armed=true;"
		+ "var cmd=key.getAttribute('data-cmd');"
		+ "if(cmd==='backspace'){doBackspace();stopRepeat();bsDelay=setTimeout(function(){bsRepeat=setInterval(doBackspace,70);},400);return;}"
		+ "if(cmd==='space'){addChar(' ');return;}"
		+ "if(cmd==='clear'){text='';updateUI();return;}"
		+ "if(cmd==='shift'){upper=!upper;updateShift();return;}"
		+ "if(cmd==='layout'){showPad(key.getAttribute('data-layout')||'ru');return;}"
		+ "if(cmd==='done'){var href=text.length?'app:done:'+pack(text):'app:done';"
		+ "var a=document.createElement('a');a.href=href;a.style.display='none';document.body.appendChild(a);a.click();return;}"
		+ "if(cmd==='back'){window.location='app:back';return;}"
		+ "var ch=key.getAttribute('data-ch');if(ch)addChar(ch);}"
		+ "function onUp(e){armed=false;stopRepeat();}"
		+ "document.addEventListener('touchstart',onDown,{passive:false,capture:true});"
		+ "document.addEventListener('mousedown',onDown,true);"
		+ "document.addEventListener('touchend',onUp,true);"
		+ "document.addEventListener('mouseup',onUp,true);"
		+ "document.addEventListener('touchcancel',onUp,true);"
		+ "document.addEventListener('click',function(e){if(findKey(e.target)){if(e.cancelable)e.preventDefault();e.stopPropagation();}},true);"
		+ "document.addEventListener('selectstart',function(e){e.preventDefault();});"
		+ "document.addEventListener('contextmenu',function(e){e.preventDefault();});"
		+ "updateUI();showPad(layout);"
		+ "})();";
	
КонецФункции

&НаСервере
Функция ТекстКакFromCharCode(Знач Текст)
	
	Если Не ЗначениеЗаполнено(Текст) Тогда
		
		Возврат """""";
		
	КонецЕсли;
	
	Коды = Новый Массив;
	
	Для Номер = 1 По СтрДлина(Текст) Цикл
		
		Коды.Добавить(Формат(КодСимвола(Сред(Текст, Номер, 1)), "ЧН=0; ЧГ="));
		
	КонецЦикла;
	
	Возврат "String.fromCharCode(" + СтрСоединить(Коды, ",") + ")";
	
КонецФункции

&НаСервере
Функция СтилиКлавиатуры()
	
	Возврат "*{box-sizing:border-box;margin:0;padding:0;-webkit-tap-highlight-color:rgba(37,99,235,0.12);"
		+ "-webkit-user-select:none;user-select:none;-webkit-touch-callout:none;-webkit-user-drag:none}"
		+ "html,body{touch-action:manipulation;overscroll-behavior:none}"
		+ "body{font-family:-apple-system,BlinkMacSystemFont,""Segoe UI"",Roboto,Arial,sans-serif;background:#FAFAFA;color:#111827;"
		+ "min-height:100vh;display:flex;align-items:flex-end}"
		+ "a{text-decoration:none;color:inherit;-webkit-user-select:none;user-select:none;outline:none}"
		+ ".sheet{width:100%;background:#fff;border-radius:16px 16px 0 0;padding:12px 10px calc(12px + env(safe-area-inset-bottom,0px));"
		+ "box-shadow:0 -4px 20px rgba(17,24,39,0.06)}"
		+ ".top{display:flex;align-items:center;justify-content:space-between;margin-bottom:8px;padding:0 4px}"
		+ ".title{font-size:16px;font-weight:700}"
		+ ".icon-btn{width:34px;height:34px;border-radius:50%;background:#F3F4F6;display:flex;align-items:center;"
		+ "justify-content:center;color:#6B7280;touch-action:manipulation}"
		+ ".icon-btn.ghost{visibility:hidden}"
		+ ".field{background:#F9FAFB;border:1px solid #E5E7EB;border-radius:14px;padding:12px;margin:0 4px 10px;min-height:72px}"
		+ ".preview{font-size:16px;font-weight:600;color:#111827;line-height:1.35;min-height:44px;word-break:break-word;"
		+ "white-space:pre-wrap;-webkit-user-select:none;user-select:none}"
		+ ".preview.placeholder{color:#9CA3AF;font-weight:500}"
		+ ".meta{display:flex;justify-content:space-between;align-items:center;margin-top:8px}"
		+ ".clear-link{font-size:13px;font-weight:700;color:#DC2626;touch-action:manipulation;padding:6px 0}"
		+ ".counter{font-size:12px;color:#9CA3AF;font-weight:600}"
		+ ".pad{margin-bottom:8px}"
		+ ".pad[hidden]{display:none!important}"
		+ ".row{display:flex;justify-content:center;margin:0 0 5px}"
		+ ".key{flex:1;min-width:0;height:44px;margin:0 2px;border-radius:10px;background:#fff;border:1px solid #E5E7EB;"
		+ "display:flex;align-items:center;justify-content:center;font-size:16px;font-weight:600;color:#111827;"
		+ "touch-action:manipulation;-webkit-user-select:none;user-select:none}"
		+ ".key.mod{flex:1.2;font-size:12px;font-weight:700;color:#374151;background:#F3F4F6}"
		+ ".key.mod.active,.key.shift-key.active{background:#DBEAFE;border-color:#2563EB;color:#2563EB}"
		+ ".key.space{flex:3.2;font-size:14px;color:#6B7280}"
		+ ".key:active{background:#EFF6FF;border-color:#3B82F6}"
		+ ".actions{padding:0 4px}"
		+ ".done{display:flex;align-items:center;justify-content:center;height:48px;border-radius:14px;background:#2563EB;"
		+ "color:#fff;font-size:16px;font-weight:700;touch-action:manipulation}";
	
КонецФункции

&НаСервере
Функция SVGСтрелкаНазад()
	
	Возврат "<svg width=""18"" height=""18"" viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""><path d=""M15 18l-6-6 6-6""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGBackspace()
	
	Возврат "<svg width=""18"" height=""18"" viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""><path d=""M21 4H8l-7 8 7 8h13a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2z""/><path d=""M18 9l-6 6""/><path d=""M12 9l6 6""/></svg>";
	
КонецФункции

&НаСервере
Функция ЭкранироватьHTML(Знач Текст)
	
	Результат = Строка(Текст);
	Результат = СтрЗаменить(Результат, "&", "&amp;");
	Результат = СтрЗаменить(Результат, "<", "&lt;");
	Результат = СтрЗаменить(Результат, ">", "&gt;");
	Результат = СтрЗаменить(Результат, """", "&quot;");
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЭкранироватьАтрибут(Знач Текст)
	
	Результат = ЭкранироватьHTML(Текст);
	Результат = СтрЗаменить(Результат, "'", "&#39;");
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ИзвлечьКомандуИзСсылки(Знач АдресСсылки)
	
	Если Не ЗначениеЗаполнено(АдресСсылки) Тогда
		
		Возврат "";
		
	КонецЕсли;
	
	Позиция = СтрНайти(НРег(СокрЛП(АдресСсылки)), "app:");
	
	Если Позиция = 0 Тогда
		
		Возврат "";
		
	КонецЕсли;
	
	Возврат Сред(СокрЛП(АдресСсылки), Позиция + 4);
	
КонецФункции

#КонецОбласти
