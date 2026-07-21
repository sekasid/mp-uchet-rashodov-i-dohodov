////////////////////////////////////////////////////////////////////////////////
// Форма обработки «Начальный экран».
// Главная, счета с остатками и аналитика — страницы одной формы.
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВалютаУчета = Константы.ВалютаУчета.Получить();
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаОсновная;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПробужденииКлиентскогоПриложения()
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "МобильнаяНавигация" Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Параметр = "home" Тогда
		
		ПоказатьГлавнуюСтраницу();
		
	ИначеЕсли Параметр = "reports" Тогда
		
		ПоказатьСтраницуОтчетов();
		
	ИначеЕсли Параметр = "menu" Или Параметр = "catalogs" Тогда
		
		ПоказатьСтраницуМеню();
		
	ИначеЕсли Параметр = "operations" Тогда
		
		ПоказатьСтраницуОпераций();
		
	ИначеЕсли Параметр = "settings" Тогда
		
		ПоказатьСтраницуНастроек();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьРасход(Команда)
	
	ОткрытьФормуБыстрогоВвода("Расход");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДоход(Команда)
	
	ОткрытьФормуБыстрогоВвода("Приход");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыДокумента(Результат, ПараметрыРезультата) Экспорт
	
	Если Результат <> Истина Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетРасходы(Команда)
	
	ОткрытьОтчетПоКатегориям(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетПоДоходам(Команда)
	
	ОткрытьОтчетПоКатегориям(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетПоВзаиморасчетам(Команда)
	
	ОткрытьОтчетПоСчетам();
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьсяНаОсновнуюСтраницу(Команда)
	
	ПоказатьГлавнуюСтраницу();
	
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

&НаКлиенте
Процедура ПолеHTMLАналитикиПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	КомандаПриложения = ИзвлечьКомандуИзСсылки(ДанныеСобытия.Href);
	
	Если Не ЗначениеЗаполнено(КомандаПриложения) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ОбработатьКомандуАналитики(КомандаПриложения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТекстHTML = СобратьHTMLГлавнойСтраницы();
	
КонецПроцедуры

&НаСервере
Функция СобратьHTMLГлавнойСтраницы()
	
	Результат = ТекстМакетаГлавнойСтраницы();
	
	ДанныеСчетов = ПолучитьДанныеСчетовСОстатками();
	ДанныеСводки = ПолучитьДанныеСводки();
	Счётчики = ПолучитьСчётчикиОперацийЗаМесяц();
	
	ОстатокТекст = ОбщийМодульСервер_КурсыВалют.ПредставлениеСуммыВВалютеУчетаДляHTML(ДанныеСчетов.Итого, Ложь);
	ДоходыТекст = ОбщийМодульСервер_КурсыВалют.ПредставлениеСуммыВВалютеУчетаДляHTML(ДанныеСводки.МесяцДоходы, Ложь);
	РасходыТекст = ОбщийМодульСервер_КурсыВалют.ПредставлениеСуммыВВалютеУчетаДляHTML(ДанныеСводки.МесяцРасходы, Ложь);
	ДоходыПодпись = ЭкранироватьHTML(ПредставлениеКоличестваОпераций(Счётчики.Доходы));
	РасходыПодпись = ЭкранироватьHTML(ПредставлениеКоличестваОпераций(Счётчики.Расходы));
	
	Результат = СтрЗаменить(Результат, "#Период#", ЭкранироватьHTML(ПредставлениеПериодаМесяцаHTML()));
	Результат = СтрЗаменить(Результат, "#ОбщийОстаток#", ОстатокТекст);
	Результат = СтрЗаменить(Результат, "#СуммаДоходов#", ДоходыТекст);
	Результат = СтрЗаменить(Результат, "#СуммаРасходов#", РасходыТекст);
	Результат = СтрЗаменить(Результат, "#ПодписьДоходов#", ДоходыПодпись);
	Результат = СтрЗаменить(Результат, "#ПодписьРасходов#", РасходыПодпись);
	Результат = СтрЗаменить(Результат, "#ПоследниеОперации#", СформироватьHTMLПоследнихОпераций(5));
	
	Возврат Результат;
	
КонецФункции

// HTML-страница со всеми счетами и остатками (открывается по «Все» / «Счета»).
//
&НаСервере
Функция СобратьHTMLСтраницыВсехСчетов()
	
	ДанныеСчетов = ПолучитьДанныеСчетовСОстатками();
	ПредставлениеВалюты = ?(ЗначениеЗаполнено(ВалютаУчета), Строка(ВалютаУчета), "—");
	
	Строки = Новый Массив;
	Строки.Добавить("<!DOCTYPE html>");
	Строки.Добавить("<html lang=""ru"">");
	Строки.Добавить("<head>");
	Строки.Добавить("<meta charset=""utf-8"">");
	Строки.Добавить("<meta name=""viewport"" content=""width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"">");
	Строки.Добавить("<style>");
	Строки.Добавить(СтилиWalletБазовые());
	Строки.Добавить(".back{display:inline-block;margin-bottom:12px;font-size:14px;font-weight:600;color:#2563EB;padding:4px 0}");
	Строки.Добавить(".header{margin-bottom:12px}");
	Строки.Добавить(".header .title{font-size:24px;font-weight:700;letter-spacing:-0.03em}");
	Строки.Добавить(".header .sub{margin-top:2px;font-size:12px;color:#6B7280}");
	Строки.Добавить(".card{background:#fff;border-radius:16px;padding:8px 12px;border:1px solid #E5E7EB}");
	Строки.Добавить(".row{display:flex;align-items:center;justify-content:space-between;padding:10px 0;border-top:1px solid #E5E7EB;gap:8px}");
	Строки.Добавить(".row:first-of-type{border-top:none}");
	Строки.Добавить(".row .name{font-size:14px;color:#374151;flex:1;min-width:0;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}");
	Строки.Добавить(".row .sum{font-size:14px;font-weight:600;white-space:nowrap}");
	Строки.Добавить(".row .sum.neg{color:#DC2626}");
	Строки.Добавить(".row .sum.pos{color:#16A34A}");
	Строки.Добавить(".row .sum.zero{color:#111827}");
	Строки.Добавить(".row .left{display:flex;align-items:center;gap:8px;flex:1;min-width:0}");
	Строки.Добавить(".row .ico-wrap{width:22px;height:22px;flex-shrink:0;display:flex;align-items:center;justify-content:center;color:#6B7280}");
	Строки.Добавить(".row .ico-wrap svg{display:block;width:18px;height:18px}");
	Строки.Добавить(".total{margin-top:4px;padding-top:10px;border-top:1px solid #E5E7EB;display:flex;justify-content:space-between;gap:8px;font-size:14px;font-weight:700}");
	Строки.Добавить(".empty{padding:12px 0;font-size:14px;color:#6B7280}");
	Строки.Добавить("</style>");
	Строки.Добавить("</head>");
	Строки.Добавить("<body>");
	Строки.Добавить("<a class=""back"" href=""app:catalogs"">← Назад</a>");
	Строки.Добавить("<div class=""header"">");
	Строки.Добавить("<div class=""title"">Счета</div>");
	Строки.Добавить("<div class=""sub"">" + ЭкранироватьHTML(ПредставлениеВалюты + " · остатки") + "</div>");
	Строки.Добавить("</div>");
	Строки.Добавить("<div class=""card"">");
	
	Если ДанныеСчетов.СтрокиHTML = "" Тогда
		
		Строки.Добавить("<div class=""empty"">Добавьте счёт</div>");
		
	Иначе
		
		Строки.Добавить(ДанныеСчетов.СтрокиHTML);
		Строки.Добавить("<div class=""total""><span>Итого</span><span>"
			+ ЭкранироватьHTML(ФорматСуммыHTML(ДанныеСчетов.Итого, Ложь)) + "</span></div>");
		
	КонецЕсли;
	
	Строки.Добавить("</div>");
	Строки.Добавить(HTMLНижняяНавигация("catalogs"));
	Строки.Добавить("</body>");
	Строки.Добавить("</html>");
	
	Возврат СтрСоединить(Строки, Символы.ПС);
	
КонецФункции

// HTML-каркас главной по макету Wallet (Notion): остаток, доходы/расходы, последние операции, FAB.
// Копии: docs/ui/dashboard.html, Templates/.../Template.txt
//
&НаСервере
Функция ТекстМакетаГлавнойСтраницы()
	
	Строки = Новый Массив;
	Строки.Добавить("<!DOCTYPE html>");
	Строки.Добавить("<html lang=""ru"">");
	Строки.Добавить("<head>");
	Строки.Добавить("<meta charset=""utf-8"">");
	Строки.Добавить("<meta name=""viewport"" content=""width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"">");
	Строки.Добавить("<style>");
	Строки.Добавить(СтилиWalletБазовые());
	Строки.Добавить(".top{display:flex;align-items:flex-start;justify-content:space-between;gap:10px;margin-bottom:10px}");
	Строки.Добавить(".top h1{font-size:24px;font-weight:700;letter-spacing:-0.03em}");
	Строки.Добавить(".cal{width:36px;height:36px;border-radius:12px;background:#fff;border:1px solid #E5E7EB;display:flex;align-items:center;justify-content:center;color:#6B7280}");
	Строки.Добавить(".period{display:inline-flex;align-items:center;gap:6px;margin-bottom:12px;padding:8px 12px;border-radius:999px;background:#F3F4F6;font-size:13px;font-weight:600;color:#6B7280}");
	Строки.Добавить(".balance{background:#fff;border:1px solid #E5E7EB;border-radius:16px;padding:16px;margin-bottom:10px}");
	Строки.Добавить(".balance .lbl{font-size:13px;font-weight:600;color:#6B7280}");
	Строки.Добавить(".balance .val{margin-top:4px;font-size:36px;font-weight:700;letter-spacing:-0.03em;line-height:1.1}");
	Строки.Добавить(".balance .hint{margin-top:6px;font-size:12px;color:#6B7280}");
	Строки.Добавить(".stats{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:14px}");
	Строки.Добавить(".stat{background:#fff;border:1px solid #E5E7EB;border-radius:16px;padding:12px}");
	Строки.Добавить(".stat .ico{width:28px;height:28px;border-radius:50%;display:flex;align-items:center;justify-content:center;margin-bottom:8px}");
	Строки.Добавить(".stat .ico.income{background:#ECFDF5;color:#16A34A}");
	Строки.Добавить(".stat .ico.expense{background:#FEF2F2;color:#DC2626}");
	Строки.Добавить(".stat .lbl{font-size:12px;font-weight:600;color:#6B7280}");
	Строки.Добавить(".stat .val{margin-top:2px;font-size:16px;font-weight:700}");
	Строки.Добавить(".stat .val.income{color:#16A34A}");
	Строки.Добавить(".stat .val.expense{color:#DC2626}");
	Строки.Добавить(".stat .sub{margin-top:2px;font-size:12px;color:#6B7280}");
	Строки.Добавить(".sec-head{display:flex;align-items:center;justify-content:space-between;margin-bottom:8px}");
	Строки.Добавить(".sec-head h2{font-size:16px;font-weight:700}");
	Строки.Добавить(".sec-head .all{font-size:14px;font-weight:600;color:#2563EB}");
	Строки.Добавить(".ops{background:#fff;border:1px solid #E5E7EB;border-radius:16px;padding:4px 12px;margin-bottom:72px}");
	Строки.Добавить(".op{display:flex;align-items:center;gap:10px;padding:12px 0;border-top:1px solid #E5E7EB}");
	Строки.Добавить(".op:first-child{border-top:none}");
	Строки.Добавить(".op .badge{width:36px;height:36px;border-radius:50%;flex-shrink:0;display:flex;align-items:center;justify-content:center}");
	Строки.Добавить(".op .badge.income{background:#ECFDF5;color:#16A34A}");
	Строки.Добавить(".op .badge.expense{background:#FEF2F2;color:#DC2626}");
	Строки.Добавить(".op .badge.transfer{background:#EFF6FF;color:#2563EB}");
	Строки.Добавить(".op .mid{flex:1;min-width:0}");
	Строки.Добавить(".op .title{font-size:15px;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}");
	Строки.Добавить(".op .acc{margin-top:1px;font-size:12px;color:#6B7280;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}");
	Строки.Добавить(".op .right{text-align:right;flex-shrink:0}");
	Строки.Добавить(".op .sum{display:block;font-size:15px;font-weight:700}");
	Строки.Добавить(".op .sum.income{color:#16A34A}");
	Строки.Добавить(".op .sum.expense{color:#DC2626}");
	Строки.Добавить(".op .sum.transfer{color:#2563EB}");
	Строки.Добавить(".op .date{display:block;margin-top:1px;font-size:12px;color:#6B7280}");
	Строки.Добавить(".empty{padding:16px 0;font-size:14px;color:#6B7280;text-align:center}");
	Строки.Добавить(".fab{position:fixed;right:16px;bottom:72px;width:56px;height:56px;border-radius:50%;background:#2563EB;color:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 6px 16px rgba(37,99,235,0.35);z-index:11}");
	Строки.Добавить("</style>");
	Строки.Добавить("</head>");
	Строки.Добавить("<body>");
	Строки.Добавить("<div class=""top""><h1>Главная</h1><a class=""cal"" href=""app:period:Месяц"">" + SVGИконкаКалендарь("#6B7280", 18) + "</a></div>");
	Строки.Добавить("<a class=""period"" href=""app:period:Месяц"">#Период# ▾</a>");
	Строки.Добавить("<div class=""balance""><div class=""lbl"">Общий остаток</div><div class=""val"">#ОбщийОстаток#</div><div class=""hint"">на всех счетах</div></div>");
	Строки.Добавить("<div class=""stats"">");
	Строки.Добавить("<a class=""stat"" href=""app:report:dohod""><div class=""ico income"">" + SVGИконкаСтрелкаВниз("#16A34A", 16) + "</div><div class=""lbl"">Доходы</div><div class=""val income"">#СуммаДоходов#</div><div class=""sub"">#ПодписьДоходов#</div></a>");
	Строки.Добавить("<a class=""stat"" href=""app:report:rashod""><div class=""ico expense"">" + SVGИконкаКошелекДенег("#DC2626", 16) + "</div><div class=""lbl"">Расходы</div><div class=""val expense"">#СуммаРасходов#</div><div class=""sub"">#ПодписьРасходов#</div></a>");
	Строки.Добавить("</div>");
	Строки.Добавить("<div class=""sec-head""><h2>Последние операции</h2><a class=""all"" href=""app:operations"">Все</a></div>");
	Строки.Добавить("<div class=""ops"">#ПоследниеОперации#</div>");
	Строки.Добавить("<a class=""fab"" href=""app:fab"">" + SVGИконкаПлюс("#fff", 28) + "</a>");
	Строки.Добавить(HTMLНижняяНавигация("home"));
	Строки.Добавить("</body>");
	Строки.Добавить("</html>");
	
	Возврат СтрСоединить(Строки, Символы.ПС);
	
КонецФункции

// Нижняя панель Wallet: Главная · Операции · Отчёты · Справочники · Настройки.
// АктивныйПункт: home | operations | reports | catalogs | settings
//
&НаСервере
Функция HTMLНижняяНавигация(АктивныйПункт)
	
	КлассHome = ?(АктивныйПункт = "home", "active", "");
	КлассOps = ?(АктивныйПункт = "operations", "active", "");
	КлассReports = ?(АктивныйПункт = "reports", "active", "");
	КлассCatalogs = "";
	КлассSettings = ?(АктивныйПункт = "settings", "active", "");
	
	Если АктивныйПункт = "catalogs" Или АктивныйПункт = "menu" Тогда
		
		КлассCatalogs = "active";
		
	КонецЕсли;
	
	Возврат "<nav class=""nav"">"
		+ "<a class=""" + КлассHome + """ href=""app:home""><span class=""ico"">" + SVGИконкаДом("currentColor")
		+ "</span>Главная</a>"
		+ "<a class=""" + КлассOps + """ href=""app:operations""><span class=""ico"">" + SVGИконкаПеревод("currentColor", 18)
		+ "</span>Операции</a>"
		+ "<a class=""" + КлассReports + """ href=""app:reports""><span class=""ico"">" + SVGИконкаДиаграмма("currentColor")
		+ "</span>Отчёты</a>"
		+ "<a class=""" + КлассCatalogs + """ href=""app:catalogs""><span class=""ico"">" + SVGИконкаПапка("currentColor")
		+ "</span>Справочники</a>"
		+ "<a class=""" + КлассSettings + """ href=""app:settings""><span class=""ico"">" + SVGИконкаНастройки("currentColor")
		+ "</span>Настройки</a>"
		+ "</nav>";
	
КонецФункции

// Общие стили страниц Wallet (фон, ссылки, нижняя навигация).
//
&НаСервере
Функция СтилиWalletБазовые()
	
	Возврат "*{box-sizing:border-box;margin:0;padding:0;-webkit-tap-highlight-color:transparent}"
		+ "body{font-family:-apple-system,BlinkMacSystemFont,""Segoe UI"",Roboto,Arial,sans-serif;background:#FAFAFA;color:#111827;padding:14px 16px 88px;line-height:1.3}"
		+ "a{text-decoration:none;color:inherit;display:block}"
		+ ".nav{position:fixed;left:0;right:0;bottom:0;background:#fff;border-top:1px solid #E5E7EB;display:flex;padding:6px 2px calc(6px + env(safe-area-inset-bottom,0px));z-index:10}"
		+ ".nav a{flex:1;text-align:center;padding:4px 1px;color:#6B7280;font-size:9px;font-weight:600;line-height:1.15}"
		+ ".nav .ico{height:18px;display:flex;align-items:center;justify-content:center;margin-bottom:2px}"
		+ ".nav .ico svg{display:block;width:18px;height:18px}"
		+ ".nav a.active{color:#2563EB}";
	
КонецФункции

// HTML-страница справочников по макету Wallet.
//
&НаСервере
Функция СобратьHTMLСтраницыМеню()
	
	Возврат СобратьHTMLСтраницыСправочников();
	
КонецФункции

// HTML-страница «Справочники».
//
&НаСервере
Функция СобратьHTMLСтраницыСправочников()
	
	Строки = Новый Массив;
	Строки.Добавить("<!DOCTYPE html><html lang=""ru""><head><meta charset=""utf-8"">");
	Строки.Добавить("<meta name=""viewport"" content=""width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"">");
	Строки.Добавить("<style>");
	Строки.Добавить(СтилиWalletБазовые());
	Строки.Добавить(".top{display:flex;align-items:center;justify-content:space-between;margin-bottom:14px}");
	Строки.Добавить(".top h1{font-size:24px;font-weight:700}");
	Строки.Добавить(".plus{width:36px;height:36px;border-radius:50%;background:#F3F4F6;display:flex;align-items:center;justify-content:center;color:#6B7280}");
	Строки.Добавить(".item{display:flex;align-items:center;gap:12px;background:#fff;border:1px solid #E5E7EB;border-radius:16px;padding:14px;margin-bottom:10px}");
	Строки.Добавить(".item .badge{width:40px;height:40px;border-radius:50%;flex-shrink:0;display:flex;align-items:center;justify-content:center}");
	Строки.Добавить(".item .mid{flex:1;min-width:0}");
	Строки.Добавить(".item .name{font-size:16px;font-weight:700}");
	Строки.Добавить(".item .chev{color:#C0C7D1;font-size:20px}");
	Строки.Добавить(".fab{position:fixed;right:16px;bottom:72px;width:56px;height:56px;border-radius:50%;background:#2563EB;color:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 6px 16px rgba(37,99,235,0.35);z-index:11}");
	Строки.Добавить("</style></head><body>");
	Строки.Добавить("<div class=""top""><h1>Справочники</h1><a class=""plus"" href=""app:fab"">" + SVGИконкаПлюс("#6B7280", 18) + "</a></div>");
	Строки.Добавить(HTMLКарточкаСправочника("Счета", "open:accounts", "#EFF6FF", "#2563EB", SVGИконкаКарта("#2563EB", 20)));
	Строки.Добавить(HTMLКарточкаСправочника("Категории доходов", "open:categories-income", "#F0FDFA", "#14B8A6", SVGИконкаСтрелкаВниз("#14B8A6", 18)));
	Строки.Добавить(HTMLКарточкаСправочника("Категории расходов", "open:categories-expense", "#FEF2F2", "#DC2626", SVGИконкаСтрелкаВверх("#DC2626", 18)));
	Строки.Добавить(HTMLКарточкаСправочника("Контакты", "open:contacts", "#F5F3FF", "#7C3AED", SVGИконкаДолги("#7C3AED", 18)));
	Строки.Добавить(HTMLКарточкаСправочника("Валюты", "open:currency", "#ECFDF5", "#16A34A", SVGИконкаБанк("#16A34A", 18)));
	Строки.Добавить("<a class=""fab"" href=""app:fab"">" + SVGИконкаПлюс("#fff", 28) + "</a>");
	Строки.Добавить(HTMLНижняяНавигация("catalogs"));
	Строки.Добавить("</body></html>");
	
	Возврат СтрСоединить(Строки, Символы.ПС);
	
КонецФункции

// Карточка пункта меню справочников: иконка, название, стрелка.
//
&НаСервере
Функция HTMLКарточкаСправочника(Заголовок, Команда, ФонБейджа, ЦветИконки, SVG)
	
	Возврат "<a class=""item"" href=""app:" + Команда + """>"
		+ "<span class=""badge"" style=""background:" + ФонБейджа + ";color:" + ЦветИконки + """>" + SVG + "</span>"
		+ "<span class=""mid""><span class=""name"">" + ЭкранироватьHTML(Заголовок) + "</span></span>"
		+ "<span class=""chev"">›</span></a>";
	
КонецФункции

// HTML-страница списка отчётов по макету Wallet.
//
&НаСервере
Функция СобратьHTMLСтраницыОтчетов()
	
	Строки = Новый Массив;
	Строки.Добавить("<!DOCTYPE html><html lang=""ru""><head><meta charset=""utf-8"">");
	Строки.Добавить("<meta name=""viewport"" content=""width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"">");
	Строки.Добавить("<style>");
	Строки.Добавить(СтилиWalletБазовые());
	Строки.Добавить("h1{font-size:24px;font-weight:700;margin-bottom:10px}");
	Строки.Добавить(".period{display:inline-flex;margin-bottom:14px;padding:8px 12px;border-radius:999px;background:#F3F4F6;font-size:13px;font-weight:600;color:#6B7280}");
	Строки.Добавить(".item{display:flex;align-items:center;justify-content:space-between;gap:12px;background:#fff;border:1px solid #E5E7EB;border-radius:16px;padding:16px;margin-bottom:10px}");
	Строки.Добавить(".item .name{font-size:16px;font-weight:700}");
	Строки.Добавить(".item .ico{width:40px;height:40px;border-radius:12px;background:#F3F4F6;display:flex;align-items:center;justify-content:center;flex-shrink:0}");
	Строки.Добавить("</style></head><body>");
	Строки.Добавить("<h1>Отчёты</h1>");
	Строки.Добавить("<div class=""period"">Период " + ЭкранироватьHTML(ПредставлениеПериодаМесяцаHTML()) + "</div>");
	Строки.Добавить("<a class=""item"" href=""app:report:accounts""><span class=""name"">Доходы и расходы</span><span class=""ico"">" + SVGИконкаДиаграммаСтолбцы("#2563EB") + "</span></a>");
	Строки.Добавить("<a class=""item"" href=""app:report:rashod""><span class=""name"">Структура расходов</span><span class=""ico"">" + SVGИконкаДиаграмма("#DC2626") + "</span></a>");
	Строки.Добавить("<a class=""item"" href=""app:report:dohod""><span class=""name"">Структура доходов</span><span class=""ico"">" + SVGИконкаДиаграмма("#16A34A") + "</span></a>");
	Строки.Добавить("<a class=""item"" href=""app:operations""><span class=""name"">Операции</span><span class=""ico"">" + SVGИконкаСписок("#2563EB") + "</span></a>");
	Строки.Добавить(HTMLНижняяНавигация("reports"));
	Строки.Добавить("</body></html>");
	
	Возврат СтрСоединить(Строки, Символы.ПС);
	
КонецФункции

// HTML-страница списка операций: шапка и период закреплены, листается только список.
//
&НаСервере
Функция СобратьHTMLСтраницыОпераций()
	
	Строки = Новый Массив;
	Строки.Добавить("<!DOCTYPE html><html lang=""ru""><head><meta charset=""utf-8"">");
	Строки.Добавить("<meta name=""viewport"" content=""width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"">");
	Строки.Добавить("<style>");
	Строки.Добавить("*{box-sizing:border-box;margin:0;padding:0;-webkit-tap-highlight-color:transparent}");
	Строки.Добавить("html,body{height:100%;overflow:hidden}");
	Строки.Добавить("body{font-family:-apple-system,BlinkMacSystemFont,""Segoe UI"",Roboto,Arial,sans-serif;background:#FAFAFA;color:#111827;display:flex;flex-direction:column;line-height:1.3}");
	Строки.Добавить("a{text-decoration:none;color:inherit;display:block}");
	Строки.Добавить(".page-top{flex-shrink:0;padding:14px 16px 10px;background:#FAFAFA;border-bottom:1px solid #E5E7EB;z-index:5}");
	Строки.Добавить(".page-top h1{font-size:24px;font-weight:700}");
	Строки.Добавить(".page-top .period{display:inline-flex;margin-top:8px;padding:8px 12px;border-radius:999px;background:#F3F4F6;font-size:13px;font-weight:600;color:#6B7280}");
	Строки.Добавить(".ops-wrap{flex:1;min-height:0;overflow-y:auto;-webkit-overflow-scrolling:touch;padding:10px 16px 88px}");
	Строки.Добавить(".ops{background:#fff;border:1px solid #E5E7EB;border-radius:16px;padding:4px 12px}");
	Строки.Добавить(".op{display:flex;align-items:center;gap:10px;padding:12px 0;border-top:1px solid #E5E7EB}");
	Строки.Добавить(".op:first-child{border-top:none}");
	Строки.Добавить(".op .badge{width:36px;height:36px;border-radius:50%;flex-shrink:0;display:flex;align-items:center;justify-content:center}");
	Строки.Добавить(".op .badge.income{background:#ECFDF5;color:#16A34A}");
	Строки.Добавить(".op .badge.expense{background:#FEF2F2;color:#DC2626}");
	Строки.Добавить(".op .badge.transfer{background:#EFF6FF;color:#2563EB}");
	Строки.Добавить(".op .mid{flex:1;min-width:0}");
	Строки.Добавить(".op .title{display:block;font-size:15px;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}");
	Строки.Добавить(".op .right{text-align:right;flex-shrink:0}");
	Строки.Добавить(".op .sum{display:block;font-size:15px;font-weight:700;white-space:nowrap}");
	Строки.Добавить(".op .sum.income{color:#16A34A}");
	Строки.Добавить(".op .sum.expense{color:#DC2626}");
	Строки.Добавить(".op .sum.transfer{color:#2563EB}");
	Строки.Добавить(".op .date{display:block;margin-top:1px;font-size:12px;color:#6B7280}");
	Строки.Добавить(".empty{padding:24px 0;font-size:14px;color:#6B7280;text-align:center}");
	Строки.Добавить(".fab{position:fixed;right:16px;bottom:72px;width:56px;height:56px;border-radius:50%;background:#2563EB;color:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 6px 16px rgba(37,99,235,0.35);z-index:11}");
	Строки.Добавить(".nav{position:fixed;left:0;right:0;bottom:0;background:#fff;border-top:1px solid #E5E7EB;display:flex;padding:6px 2px calc(6px + env(safe-area-inset-bottom,0px));z-index:10}");
	Строки.Добавить(".nav a{flex:1;text-align:center;padding:4px 1px;color:#6B7280;font-size:9px;font-weight:600;line-height:1.15}");
	Строки.Добавить(".nav .ico{height:18px;display:flex;align-items:center;justify-content:center;margin-bottom:2px}");
	Строки.Добавить(".nav .ico svg{display:block;width:18px;height:18px}");
	Строки.Добавить(".nav a.active{color:#2563EB}");
	Строки.Добавить("</style></head><body>");
	Строки.Добавить("<div class=""page-top""><h1>Операции</h1><div class=""period"">"
		+ ЭкранироватьHTML(ПредставлениеПериодаМесяцаHTML()) + "</div></div>");
	Строки.Добавить("<div class=""ops-wrap""><div class=""ops"">" + СформироватьHTMLПоследнихОпераций(50) + "</div></div>");
	Строки.Добавить("<a class=""fab"" href=""app:fab"">" + SVGИконкаПлюс("#fff", 28) + "</a>");
	Строки.Добавить(HTMLНижняяНавигация("operations"));
	Строки.Добавить("</body></html>");
	
	Возврат СтрСоединить(Строки, Символы.ПС);
	
КонецФункции

// HTML-страница настроек.
//
&НаСервере
Функция СобратьHTMLСтраницыНастроек()
	
	Строки = Новый Массив;
	Строки.Добавить("<!DOCTYPE html><html lang=""ru""><head><meta charset=""utf-8"">");
	Строки.Добавить("<meta name=""viewport"" content=""width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"">");
	Строки.Добавить("<style>");
	Строки.Добавить(СтилиWalletБазовые());
	Строки.Добавить("h1{font-size:24px;font-weight:700;margin-bottom:14px}");
	Строки.Добавить(".card{background:#fff;border:1px solid #E5E7EB;border-radius:16px;padding:4px 12px}");
	Строки.Добавить(".row{display:flex;align-items:center;justify-content:space-between;padding:14px 0;border-top:1px solid #E5E7EB}");
	Строки.Добавить(".row:first-child{border-top:none}");
	Строки.Добавить(".row .name{font-size:15px;font-weight:600}");
	Строки.Добавить(".row .chev{color:#C0C7D1;font-size:18px}");
	Строки.Добавить("</style></head><body>");
	Строки.Добавить("<h1>Настройки</h1>");
	Строки.Добавить("<div class=""card"">");
	Строки.Добавить(HTMLСтрокаМеню("Константы", "open:constants"));
	Строки.Добавить(HTMLСтрокаМеню("Документы доходов", "open:doc-income"));
	Строки.Добавить(HTMLСтрокаМеню("Документы расходов", "open:doc-expense"));
	Строки.Добавить(HTMLСтрокаМеню("Документы переводов", "open:doc-transfer"));
	Строки.Добавить(HTMLСтрокаМеню("Документы долгов", "open:doc-debt"));
	Строки.Добавить("</div>");
	Строки.Добавить(HTMLНижняяНавигация("settings"));
	Строки.Добавить("</body></html>");
	
	Возврат СтрСоединить(Строки, Символы.ПС);
	
КонецФункции

// Выбор типа операции для FAB (+).
//
&НаСервере
Функция СобратьHTMLВыбораОперации()
	
	Строки = Новый Массив;
	Строки.Добавить("<!DOCTYPE html><html lang=""ru""><head><meta charset=""utf-8"">");
	Строки.Добавить("<meta name=""viewport"" content=""width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"">");
	Строки.Добавить("<style>");
	Строки.Добавить(СтилиWalletБазовые());
	Строки.Добавить(".back{display:inline-block;margin-bottom:12px;font-size:14px;font-weight:600;color:#2563EB}");
	Строки.Добавить("h1{font-size:24px;font-weight:700;margin-bottom:14px}");
	Строки.Добавить(".grid{display:grid;grid-template-columns:1fr 1fr;gap:10px}");
	Строки.Добавить(".action{border-radius:14px;padding:18px 10px;text-align:center;border:1px solid transparent}");
	Строки.Добавить(".action .icon{height:28px;margin-bottom:8px;display:flex;align-items:center;justify-content:center}");
	Строки.Добавить(".action .label{font-size:15px;font-weight:700}");
	Строки.Добавить(".action.rashod{background:#FEF2F2;border-color:#FECACA}.action.rashod .label{color:#DC2626}");
	Строки.Добавить(".action.dohod{background:#F0FDF4;border-color:#BBF7D0}.action.dohod .label{color:#16A34A}");
	Строки.Добавить(".action.perevod{background:#EFF6FF;border-color:#BFDBFE}.action.perevod .label{color:#2563EB}");
	Строки.Добавить(".action.dolgi{background:#F0FDFA;border-color:#99F6E4}.action.dolgi .label{color:#14B8A6}");
	Строки.Добавить("</style></head><body>");
	Строки.Добавить("<a class=""back"" href=""app:home"">← Назад</a>");
	Строки.Добавить("<h1>Новая операция</h1>");
	Строки.Добавить("<div class=""grid"">");
	Строки.Добавить("<a class=""action rashod"" href=""app:rashod""><div class=""icon"">" + SVGИконкаКарта("#DC2626", 26) + "</div><div class=""label"">Расход</div></a>");
	Строки.Добавить("<a class=""action dohod"" href=""app:dohod""><div class=""icon"">" + SVGИконкаКошелекДенег("#16A34A", 26) + "</div><div class=""label"">Доход</div></a>");
	Строки.Добавить("<a class=""action perevod"" href=""app:perevod""><div class=""icon"">" + SVGИконкаПеревод("#2563EB", 26) + "</div><div class=""label"">Перевод</div></a>");
	Строки.Добавить("<a class=""action dolgi"" href=""app:dolgi""><div class=""icon"">" + SVGИконкаДолги("#14B8A6", 26) + "</div><div class=""label"">Долги</div></a>");
	Строки.Добавить("</div>");
	Строки.Добавить(HTMLНижняяНавигация("home"));
	Строки.Добавить("</body></html>");
	
	Возврат СтрСоединить(Строки, Символы.ПС);
	
КонецФункции

&НаСервере
Функция HTMLСтрокаМеню(Заголовок, КомандаПриложения)
	
	Возврат "<a class=""row"" href=""app:" + КомандаПриложения + """>"
		+ "<span class=""name"">" + ЭкранироватьHTML(Заголовок) + "</span>"
		+ "<span class=""chev"">›</span></a>";
	
КонецФункции

&НаСервере
Функция HTMLСтрокаОтчета(Заголовок, Подсказка, КомандаПриложения)
	
	Возврат "<a class=""row"" href=""app:" + КомандаПриложения + """>"
		+ "<span class=""left""><span class=""name"">" + ЭкранироватьHTML(Заголовок) + "</span>"
		+ "<span class=""hint"">" + ЭкранироватьHTML(Подсказка) + "</span></span>"
		+ "<span class=""chev"">›</span></a>";
	
КонецФункции

&НаСервере
Функция SVGИконкаКарта(Цвет, Размер = 28)
	
	РазмерСтрока = Формат(Размер, "ЧГ=");
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""" + РазмерСтрока + """ height=""" + РазмерСтрока
		+ """ viewBox=""0 0 24 24"" fill=""none"" stroke=""" + Цвет
		+ """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<rect x=""2"" y=""5"" width=""20"" height=""14"" rx=""2""/>"
		+ "<path d=""M2 10h20""/><path d=""M6 15h3""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаКошелекДенег(Цвет, Размер = 22)
	
	РазмерСтрока = Формат(Размер, "ЧГ=");
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""" + РазмерСтрока + """ height=""" + РазмерСтрока
		+ """ viewBox=""0 0 24 24"" fill=""none"" stroke=""" + Цвет
		+ """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M8 11V8a4 4 0 0 1 8 0v3""/>"
		+ "<path d=""M6 11h12v8a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2v-8z""/>"
		+ "<path d=""M12 14v3""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаПеревод(Цвет, Размер = 22)
	
	РазмерСтрока = Формат(Размер, "ЧГ=");
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""" + РазмерСтрока + """ height=""" + РазмерСтрока
		+ """ viewBox=""0 0 24 24"" fill=""none"" stroke=""" + Цвет
		+ """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M17 1l4 4-4 4""/><path d=""M3 11V9a4 4 0 0 1 4-4h14""/>"
		+ "<path d=""M7 23l-4-4 4-4""/><path d=""M21 13v2a4 4 0 0 1-4 4H3""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаДолги(Цвет, Размер = 22)
	
	РазмерСтрока = Формат(Размер, "ЧГ=");
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""" + РазмерСтрока + """ height=""" + РазмерСтрока
		+ """ viewBox=""0 0 24 24"" fill=""none"" stroke=""" + Цвет
		+ """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M16 11a3 3 0 1 0-2.8-4""/><path d=""M8 11a3 3 0 1 1 2.8-4""/>"
		+ "<path d=""M4.5 19a5 5 0 0 1 7.5-4.3""/><path d=""M19.5 19a5 5 0 0 0-7.5-4.3""/>"
		+ "<path d=""M9 15.5l1.5 1.5L15 12""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаКошелек(Цвет, Размер = 22)
	
	РазмерСтрока = Формат(Размер, "ЧГ=");
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""" + РазмерСтрока + """ height=""" + РазмерСтрока
		+ """ viewBox=""0 0 24 24"" fill=""none"" stroke=""" + Цвет
		+ """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M19 7H5a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z""/>"
		+ "<path d=""M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2""/><path d=""M12 12v.01""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаПапка(Цвет)
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""22"" height=""22"" viewBox=""0 0 24 24"" fill=""none"" stroke="""
		+ Цвет + """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V7z""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаДиаграмма(Цвет)
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""22"" height=""22"" viewBox=""0 0 24 24"" fill=""none"" stroke="""
		+ Цвет + """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M21.21 15.89A10 10 0 1 1 8 2.83""/><path d=""M22 12A10 10 0 0 0 12 2v10z""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаДом(Цвет)
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""22"" height=""22"" viewBox=""0 0 24 24"" fill=""none"" stroke="""
		+ Цвет + """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M3 10.5L12 3l9 7.5""/><path d=""M5 9.5V20h14V9.5""/><path d=""M10 20v-6h4v6""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаМеню(Цвет)
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""22"" height=""22"" viewBox=""0 0 24 24"" fill=""none"" stroke="""
		+ Цвет + """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M4 7h16""/><path d=""M4 12h16""/><path d=""M4 17h16""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаНастройки(Цвет)
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""22"" height=""22"" viewBox=""0 0 24 24"" fill=""none"" stroke="""
		+ Цвет + """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<circle cx=""12"" cy=""12"" r=""3""/>"
		+ "<path d=""M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8V9c.3.6.9 1 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1z""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаКалендарь(Цвет, Размер = 18)
	
	РазмерСтрока = Формат(Размер, "ЧГ=");
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""" + РазмерСтрока + """ height=""" + РазмерСтрока
		+ """ viewBox=""0 0 24 24"" fill=""none"" stroke=""" + Цвет
		+ """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<rect x=""3"" y=""5"" width=""18"" height=""16"" rx=""2""/><path d=""M16 3v4""/><path d=""M8 3v4""/><path d=""M3 11h18""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаПлюс(Цвет, Размер = 24)
	
	РазмерСтрока = Формат(Размер, "ЧГ=");
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""" + РазмерСтрока + """ height=""" + РазмерСтрока
		+ """ viewBox=""0 0 24 24"" fill=""none"" stroke=""" + Цвет
		+ """ stroke-width=""2.2"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M12 5v14""/><path d=""M5 12h14""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаСтрелкаВниз(Цвет, Размер = 16)
	
	РазмерСтрока = Формат(Размер, "ЧГ=");
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""" + РазмерСтрока + """ height=""" + РазмерСтрока
		+ """ viewBox=""0 0 24 24"" fill=""none"" stroke=""" + Цвет
		+ """ stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M12 5v14""/><path d=""M19 12l-7 7-7-7""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаСтрелкаВверх(Цвет, Размер = 16)
	
	РазмерСтрока = Формат(Размер, "ЧГ=");
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""" + РазмерСтрока + """ height=""" + РазмерСтрока
		+ """ viewBox=""0 0 24 24"" fill=""none"" stroke=""" + Цвет
		+ """ stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M12 19V5""/><path d=""M5 12l7-7 7 7""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаДиаграммаСтолбцы(Цвет)
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""22"" height=""22"" viewBox=""0 0 24 24"" fill=""none"" stroke="""
		+ Цвет + """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M4 20V10""/><path d=""M10 20V4""/><path d=""M16 20v-7""/><path d=""M22 20V8""/></svg>";
	
КонецФункции

&НаСервере
Функция SVGИконкаСписок(Цвет)
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""22"" height=""22"" viewBox=""0 0 24 24"" fill=""none"" stroke="""
		+ Цвет + """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M8 6h13""/><path d=""M8 12h13""/><path d=""M8 18h13""/>"
		+ "<path d=""M3 6h.01""/><path d=""M3 12h.01""/><path d=""M3 18h.01""/></svg>";
	
КонецФункции

// Подпись периода текущего месяца для чипа на главной и в отчётах.
//
&НаСервере
Функция ПредставлениеПериодаМесяцаHTML()
	
	ТекущаяДатаСеанса = ТекущаяДата();
	Начало = НачалоМесяца(ТекущаяДатаСеанса);
	
	Возврат Формат(Начало, "ДФ=d") + "–" + Формат(ТекущаяДатаСеанса, "ДФ='d MMMM yyyy'");
	
КонецФункции

// Текст «N операций» для карточек доходов/расходов.
//
&НаСервере
Функция ПредставлениеКоличестваОпераций(Количество)
	
	Остаток10 = Количество % 10;
	Остаток100 = Количество % 100;
	
	Если Остаток10 = 1 И Остаток100 <> 11 Тогда
		
		Слово = "операция";
		
	ИначеЕсли Остаток10 >= 2 И Остаток10 <= 4 И (Остаток100 < 10 Или Остаток100 >= 20) Тогда
		
		Слово = "операции";
		
	Иначе
		
		Слово = "операций";
		
	КонецЕсли;
	
	Возврат Формат(Количество, "ЧН=0; ЧГ=") + " " + Слово;
	
КонецФункции

// Количество проведённых документов доходов и расходов за текущий месяц.
//
&НаСервере
Функция ПолучитьСчётчикиОперацийЗаМесяц()
	
	Результат = Новый Структура("Доходы, Расходы", 0, 0);
	ТекущаяДатаСеанса = ТекущаяДата();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(Доходы.Ссылка) КАК Количество
	|ИЗ
	|	Документ.Доходы КАК Доходы
	|ГДЕ
	|	Доходы.Проведен
	|	И Доходы.Дата МЕЖДУ &НачалоМесяца И &КонецМесяца
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(Расход.Ссылка) КАК Количество
	|ИЗ
	|	Документ.Расход КАК Расход
	|ГДЕ
	|	Расход.Проведен
	|	И Расход.Дата МЕЖДУ &НачалоМесяца И &КонецМесяца";
	Запрос.УстановитьПараметр("НачалоМесяца", НачалоМесяца(ТекущаяДатаСеанса));
	Запрос.УстановитьПараметр("КонецМесяца", КонецМесяца(ТекущаяДатаСеанса));
	
	Пакет = Запрос.ВыполнитьПакет();
	ВыборкаДоходы = Пакет[0].Выбрать();
	
	Если ВыборкаДоходы.Следующий() Тогда
		
		Результат.Доходы = ЧислоИзВыборки(ВыборкаДоходы.Количество);
		
	КонецЕсли;
	
	ВыборкаРасходы = Пакет[1].Выбрать();
	
	Если ВыборкаРасходы.Следующий() Тогда
		
		Результат.Расходы = ЧислоИзВыборки(ВыборкаРасходы.Количество);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// HTML-лента последних операций (доходы, расходы, переводы).
//
&НаСервере
Функция СформироватьHTMLПоследнихОпераций(ЛимитСтрок = 10)
	
	Таблица = ПолучитьТаблицуПоследнихОпераций(ЛимитСтрок);
	
	Если Таблица.Количество() = 0 Тогда
		
		Возврат "<div class=""empty"">Пока нет операций</div>";
		
	КонецЕсли;
	
	Части = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		
		ВидКласс = СтрокаТаблицы.ВидКласс;
		ЗнакСуммы = ?(ВидКласс = "expense", "−", ?(ВидКласс = "income", "+", ""));
		СуммаТекст = ЗнакСуммы + ОбщийМодульСервер_КурсыВалют.ПредставлениеСуммыВВалютеУчетаДляHTML(СтрокаТаблицы.Сумма, Ложь);
		ДатаТекст = Формат(СтрокаТаблицы.Дата, "ДФ='d MMM'");
		Иконка = ?(ВидКласс = "income", SVGИконкаСтрелкаВниз("#16A34A", 16),
			?(ВидКласс = "expense", SVGИконкаКошелекДенег("#DC2626", 16), SVGИконкаПеревод("#2563EB", 16)));
		
		Части.Добавить(
			"<div class=""op"">"
			+ "<span class=""badge " + ВидКласс + """>" + Иконка + "</span>"
			+ "<span class=""mid""><span class=""title"">" + ЭкранироватьHTML(СтрокаТаблицы.Название) + "</span></span>"
			+ "<span class=""right""><span class=""sum " + ВидКласс + """>" + СуммаТекст
			+ "</span><span class=""date"">" + ЭкранироватьHTML(ДатаТекст) + "</span></span>"
			+ "</div>");
		
	КонецЦикла;
	
	Возврат СтрСоединить(Части, "");
	
КонецФункции

// Выборка последних проведённых документов для ленты операций.
//
&НаСервере
Функция ПолучитьТаблицуПоследнихОпераций(ЛимитСтрок)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Вложенный.Дата КАК Дата,
	|	Вложенный.Название КАК Название,
	|	Вложенный.Сумма КАК Сумма,
	|	Вложенный.ВидКласс КАК ВидКласс
	|ИЗ
	|	(ВЫБРАТЬ
	|		Доходы.Дата КАК Дата,
	|		ЕСТЬNULL(Доходы.КатегорияДоходов.Наименование, ""Доход"") КАК Название,
	|		Доходы.Сумма КАК Сумма,
	|		""income"" КАК ВидКласс
	|	ИЗ
	|		Документ.Доходы КАК Доходы
	|	ГДЕ
	|		Доходы.Проведен
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Расход.Дата,
	|		ЕСТЬNULL(Расход.КатегорияРасхода.Наименование, ""Расход""),
	|		Расход.Сумма,
	|		""expense""
	|	ИЗ
	|		Документ.Расход КАК Расход
	|	ГДЕ
	|		Расход.Проведен
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Переводы.Дата,
	|		""Перевод между счетами"",
	|		Переводы.Сумма,
	|		""transfer""
	|	ИЗ
	|		Документ.Переводы КАК Переводы
	|	ГДЕ
	|		Переводы.Проведен) КАК Вложенный
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	Пока Таблица.Количество() > ЛимитСтрок Цикл
		
		Таблица.Удалить(Таблица.Количество() - 1);
		
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

&НаСервере
Функция SVGИконкаБанк(Цвет, Размер = 22)
	
	РазмерСтрока = Формат(Размер, "ЧГ=");
	
	Возврат "<svg xmlns=""http://www.w3.org/2000/svg"" width=""" + РазмерСтрока + """ height=""" + РазмерСтрока
		+ """ viewBox=""0 0 24 24"" fill=""none"" stroke=""" + Цвет
		+ """ stroke-width=""1.8"" stroke-linecap=""round"" stroke-linejoin=""round"">"
		+ "<path d=""M3 21h18""/><path d=""M3 10h18""/><path d=""M5 6l7-3 7 3""/>"
		+ "<path d=""M6 10v7""/><path d=""M10 10v7""/><path d=""M14 10v7""/><path d=""M18 10v7""/></svg>";
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеСводки()
	
	Результат = Новый Структура;
	Результат.Вставить("СегодняРасходы", 0);
	Результат.Вставить("НеделяРасходы", 0);
	Результат.Вставить("МесяцРасходы", 0);
	Результат.Вставить("СегодняДоходы", 0);
	Результат.Вставить("НеделяДоходы", 0);
	Результат.Вставить("МесяцДоходы", 0);
	
	ЗаполнитьСуммыОборотов("Расходы", Результат);
	ЗаполнитьСуммыОборотов("Доходы", Результат);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСуммыОборотов(ИмяРегистра, ДанныеСводки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = ПолучитьТекстЗапроса(ИмяРегистра);
	УстановитьПараметрыЗапроса(Запрос);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Префикс = ?(ИмяРегистра = "Расходы", "Расходы", "Доходы");
	ДанныеСводки["Сегодня" + Префикс] = ЧислоИзВыборки(Выборка.Сегодня);
	ДанныеСводки["Неделя" + Префикс] = ЧислоИзВыборки(Выборка.Неделя);
	ДанныеСводки["Месяц" + Префикс] = ЧислоИзВыборки(Выборка.Месяц);
	
КонецПроцедуры

&НаСервере
Функция ЧислоИзВыборки(Значение)
	
	Если Значение = NULL Тогда
		
		Возврат 0;
		
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

&НаСервере
Функция СформироватьHTMLСтрокиСводки(ДанныеСводки)
	
	Части = Новый Массив;
	ДобавитьСтрокуСводкиHTML(Части, "Сегодня", ДанныеСводки.СегодняДоходы - ДанныеСводки.СегодняРасходы, "Сегодня");
	ДобавитьСтрокуСводкиHTML(Части, "Неделя", ДанныеСводки.НеделяДоходы - ДанныеСводки.НеделяРасходы, "Неделя");
	ДобавитьСтрокуСводкиHTML(Части, "Месяц", ДанныеСводки.МесяцДоходы - ДанныеСводки.МесяцРасходы, "Месяц");
	
	Если Части.Количество() = 0 Тогда
		
		Возврат "<div class=""empty"">Пока нет операций</div>";
		
	КонецЕсли;
	
	Возврат СтрСоединить(Части, "");
	
КонецФункции

&НаСервере
Процедура ДобавитьСтрокуСводкиHTML(Части, ЗаголовокПериода, Сумма, ИмяПериода)
	
	КлассСуммы = КлассСуммыHTML(Сумма);
	ПредставлениеСуммы = ФорматСуммыHTML(Сумма, Истина);
	СсылкаПериода = ?(Сумма < 0, "app:period:Расходы:" + ИмяПериода, "app:period:Доходы:" + ИмяПериода);
	
	Части.Добавить(
		"<a class=""row"" href=""" + СсылкаПериода + """>"
		+ "<span class=""name"">" + ЭкранироватьHTML(ЗаголовокПериода) + "</span>"
		+ "<span class=""sum " + КлассСуммы + """>" + ЭкранироватьHTML(ПредставлениеСуммы) + "</span>"
		+ "</a>");
	
КонецПроцедуры

&НаСервере
Функция СформироватьHTMLИтогСводки(ДанныеСводки)
	
	Разница = ДанныеСводки.МесяцДоходы - ДанныеСводки.МесяцРасходы;
	
	Если Разница > 0 Тогда
		
		Текст = "Доходы больше расходов на " + ФорматСуммыHTML(Разница, Ложь);
		Класс = "pos";
		
	ИначеЕсли Разница < 0 Тогда
		
		Текст = "Расходы больше доходов на " + ФорматСуммыHTML(-Разница, Ложь);
		Класс = "neg";
		
	Иначе
		
		Текст = "Доходы и расходы за месяц равны";
		Класс = "zero";
		
	КонецЕсли;
	
	Возврат "<div class=""footer-note " + Класс + """>" + ЭкранироватьHTML(Текст) + "</div>";
	
КонецФункции

// Формирует HTML-строки счетов с остатками.
// МаксимумСтрок = 0 — все счета; иначе ограничение для главной.
//
&НаСервере
Функция СформироватьHTMLСтрокиСчетов(МаксимумСтрок = 0)
	
	ДанныеСчетов = ПолучитьДанныеСчетовСОстатками(МаксимумСтрок);
	
	Если ДанныеСчетов.СтрокиHTML = "" Тогда
		
		Возврат "<div class=""empty"">Добавьте счёт</div>";
		
	КонецЕсли;
	
	Возврат ДанныеСчетов.СтрокиHTML;
	
КонецФункции

// Выборка счетов и остатков из РН Баланс. Возвращает СтрокиHTML и Итого.
// МаксимумСтрок = 0 — без ограничения.
//
&НаСервере
Функция ПолучитьДанныеСчетовСОстатками(МаксимумСтрок = 0)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Кошелек.Ссылка КАК СчетСсылка,
	|	Кошелек.Наименование КАК НаименованиеСчета,
	|	Кошелек.ВидСчета КАК ВидСчета,
	|	СУММА(ЕСТЬNULL(БалансОстатки.СуммаОстаток, 0)) КАК Сумма
	|ИЗ
	|	Справочник.Счета КАК Кошелек
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Баланс.Остатки(&Период, ) КАК БалансОстатки
	|		ПО БалансОстатки.Счета = Кошелек.Ссылка
	|ГДЕ
	|	НЕ Кошелек.ПометкаУдаления
	|
	|СГРУППИРОВАТЬ ПО
	|	Кошелек.Ссылка,
	|	Кошелек.Наименование,
	|	Кошелек.ВидСчета
	|
	|УПОРЯДОЧИТЬ ПО
	|	НаименованиеСчета";
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	Выборка = Запрос.Выполнить().Выбрать();
	
	Части = Новый Массив;
	Итого = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Сумма = ЧислоИзВыборки(Выборка.Сумма);
		Итого = Итого + Сумма;
		
		Если МаксимумСтрок > 0 И Части.Количество() >= МаксимумСтрок Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Иконка = ИконкаВидаСчетаHTML(Выборка.ВидСчета);
		СсылкаСчета = "app:account:" + Строка(Выборка.СчетСсылка.УникальныйИдентификатор());
		КлассСуммы = КлассСуммыHTML(Сумма);
		
		Части.Добавить(
			"<a class=""row"" href=""" + СсылкаСчета + """>"
			+ "<span class=""left""><span class=""ico-wrap"">" + Иконка + "</span>"
			+ "<span class=""name"">" + ЭкранироватьHTML(Выборка.НаименованиеСчета) + "</span></span>"
			+ "<span class=""sum " + КлассСуммы + """>" + ЭкранироватьHTML(ФорматСуммыHTML(Сумма, Ложь)) + "</span>"
			+ "</a>");
		
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("СтрокиHTML", СтрСоединить(Части, ""));
	Результат.Вставить("Итого", Итого);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ИконкаВидаСчетаHTML(ВидСчета)
	
	Цвет = "#6B7280";
	
	Если ВидСчета = Перечисления.ВидСчета.Кошелек Тогда
		
		Возврат SVGИконкаКошелек(Цвет, 22);
		
	ИначеЕсли ВидСчета = Перечисления.ВидСчета.БанковскаяКарта Тогда
		
		Возврат SVGИконкаКарта(Цвет, 22);
		
	ИначеЕсли ВидСчета = Перечисления.ВидСчета.БанковскийСчет Тогда
		
		Возврат SVGИконкаБанк(Цвет, 22);
		
	КонецЕсли;
	
	Возврат SVGИконкаКошелек(Цвет);
	
КонецФункции

&НаСервере
Функция ФорматСуммыHTML(Сумма, СЗнаком)
	
	Возврат ОбщийМодульСервер_КурсыВалют.ПредставлениеСуммыВВалютеУчета(Сумма, СЗнаком);
	
КонецФункции

&НаСервере
Функция КлассСуммыHTML(Сумма)
	
	Если Сумма > 0 Тогда
		
		Возврат "pos";
		
	ИначеЕсли Сумма < 0 Тогда
		
		Возврат "neg";
		
	КонецЕсли;
	
	Возврат "zero";
	
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
Функция ПолучитьТекстЗапроса(ИмяРегистра)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	СУММА(ОборотыРегистра.СуммаОборот) КАК Сегодня
	|ПОМЕСТИТЬ ВТ_Сегодня
	|ИЗ
	|	РегистрНакопления." + ИмяРегистра + ".Обороты(&НачалоДня, &КонецДня) КАК ОборотыРегистра
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ОборотыРегистра.СуммаОборот) КАК Неделя
	|ПОМЕСТИТЬ ВТ_Неделя
	|ИЗ
	|	РегистрНакопления." + ИмяРегистра + ".Обороты(&НачалоНедели, &КонецНедели) КАК ОборотыРегистра
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ОборотыРегистра.СуммаОборот) КАК Месяц
	|ПОМЕСТИТЬ ВТ_Месяц
	|ИЗ
	|	РегистрНакопления." + ИмяРегистра + ".Обороты(&НачалоМесяца, &КонецМесяца) КАК ОборотыРегистра
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ВТ_Месяц.Месяц, 0) КАК Месяц,
	|	ЕСТЬNULL(ВТ_Неделя.Неделя, 0) КАК Неделя,
	|	ЕСТЬNULL(ВТ_Сегодня.Сегодня, 0) КАК Сегодня
	|ИЗ
	|	(ВЫБРАТЬ 1 КАК Поле) КАК Корень
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Сегодня КАК ВТ_Сегодня
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Неделя КАК ВТ_Неделя
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Месяц КАК ВТ_Месяц
	|		ПО (ИСТИНА)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Процедура УстановитьПараметрыЗапроса(Запрос)
	
	ТекущаяДатаСеанса = ТекущаяДата();
	Запрос.УстановитьПараметр("НачалоДня", НачалоДня(ТекущаяДатаСеанса));
	Запрос.УстановитьПараметр("КонецДня", КонецДня(ТекущаяДатаСеанса));
	Запрос.УстановитьПараметр("НачалоНедели", НачалоНедели(ТекущаяДатаСеанса));
	Запрос.УстановитьПараметр("КонецНедели", КонецНедели(ТекущаяДатаСеанса));
	Запрос.УстановитьПараметр("НачалоМесяца", НачалоМесяца(ТекущаяДатаСеанса));
	Запрос.УстановитьПараметр("КонецМесяца", КонецМесяца(ТекущаяДатаСеанса));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьКомандуHTML(КомандаПриложения)
	
	Если КомандаПриложения = "rashod" Тогда
		
		ОткрытьФормуБыстрогоВвода("Расход");
		
	ИначеЕсли КомандаПриложения = "dohod" Тогда
		
		ОткрытьФормуБыстрогоВвода("Приход");
		
	ИначеЕсли КомандаПриложения = "perevod" Тогда
		
		ОткрытьФормуПеревода();
		
	ИначеЕсли КомандаПриложения = "dolgi" Тогда
		
		ОткрытьФормуДолга();
		
	ИначеЕсли КомандаПриложения = "home" Тогда
		
		ПоказатьГлавнуюСтраницу();
		
	ИначеЕсли КомандаПриложения = "reports" Тогда
		
		ПоказатьСтраницуОтчетов();
		
	ИначеЕсли КомандаПриложения = "menu" Или КомандаПриложения = "catalogs" Тогда
		
		ПоказатьСтраницуМеню();
		
	ИначеЕсли КомандаПриложения = "operations" Тогда
		
		ПоказатьСтраницуОпераций();
		
	ИначеЕсли КомандаПриложения = "settings" Тогда
		
		ПоказатьСтраницуНастроек();
		
	ИначеЕсли КомандаПриложения = "fab" Тогда
		
		ПоказатьВыборОперации();
		
	ИначеЕсли КомандаПриложения = "accounts" Или КомандаПриложения = "accounts-all" Тогда
		
		ПоказатьСтраницуВсехСчетов();
		
	ИначеЕсли СтрНачинаетсяС(КомандаПриложения, "report:") Тогда
		
		ОткрытьОтчетПоКоду(Сред(КомандаПриложения, СтрДлина("report:") + 1));
		
	ИначеЕсли СтрНачинаетсяС(КомандаПриложения, "open:") Тогда
		
		ОткрытьПунктМеню(Сред(КомандаПриложения, СтрДлина("open:") + 1));
		
	ИначеЕсли СтрНачинаетсяС(КомандаПриложения, "period:") Тогда
		
		Части = СтрРазделить(КомандаПриложения, ":");
		
		Если Части.Количество() >= 3 Тогда
			
			ПоказатьСводныйОтчетПоПериоду(Части[2]);
			
		ИначеЕсли Части.Количество() = 2 Тогда
			
			ПоказатьСводныйОтчетПоПериоду(Части[1]);
			
		КонецЕсли;
		
	ИначеЕсли СтрНачинаетсяС(КомандаПриложения, "account:") Тогда
		
		ОткрытьОтчетПоСчету(Сред(КомандаПриложения, СтрДлина("account:") + 1));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьКомандуАналитики(КомандаПриложения)
	
	Если КомандаПриложения = "home" Тогда
		
		ПоказатьГлавнуюСтраницу();
		
	ИначеЕсли КомандаПриложения = "reports" Тогда
		
		ПоказатьСтраницуОтчетов();
		
	ИначеЕсли КомандаПриложения = "menu" Или КомандаПриложения = "catalogs" Тогда
		
		ПоказатьСтраницуМеню();
		
	ИначеЕсли КомандаПриложения = "operations" Тогда
		
		ПоказатьСтраницуОпераций();
		
	ИначеЕсли КомандаПриложения = "settings" Тогда
		
		ПоказатьСтраницуНастроек();
		
	ИначеЕсли КомандаПриложения = "fab" Тогда
		
		ПоказатьВыборОперации();
		
	ИначеЕсли КомандаПриложения = "rashod" Тогда
		
		ОткрытьФормуБыстрогоВвода("Расход");
		
	ИначеЕсли КомандаПриложения = "dohod" Тогда
		
		ОткрытьФормуБыстрогоВвода("Приход");
		
	ИначеЕсли КомандаПриложения = "perevod" Тогда
		
		ОткрытьФормуПеревода();
		
	ИначеЕсли КомандаПриложения = "dolgi" Тогда
		
		ОткрытьФормуДолга();
		
	ИначеЕсли СтрНачинаетсяС(КомандаПриложения, "report:") Тогда
		
		ОткрытьОтчетПоКоду(Сред(КомандаПриложения, СтрДлина("report:") + 1));
		
	ИначеЕсли СтрНачинаетсяС(КомандаПриложения, "open:") Тогда
		
		ОткрытьПунктМеню(Сред(КомандаПриложения, СтрДлина("open:") + 1));
		
	ИначеЕсли СтрНачинаетсяС(КомандаПриложения, "period:") Тогда
		
		ВидПериодаОтчета = Сред(КомандаПриложения, СтрДлина("period:") + 1);
		
		Если РежимАналитики = "Категория" Тогда
			
			ОбновитьРасшифровкуПослеСменыПериодаНаСервере();
			
		ИначеЕсли РежимАналитики <> "Счета" И РежимАналитики <> "Меню" И РежимАналитики <> "Отчеты"
			И РежимАналитики <> "Операции" И РежимАналитики <> "Настройки" И РежимАналитики <> "FAB" Тогда
			
			СформироватьСводныйОтчетНаСервере();
			
		КонецЕсли;
		
	ИначеЕсли СтрНачинаетсяС(КомандаПриложения, "category:") Тогда
		
		Части = СтрРазделить(КомандаПриложения, ":");
		
		Если Части.Количество() >= 3 Тогда
			
			ПоказатьРасшифровкуКатегории(Части[1], Части[2]);
			
		КонецЕсли;
		
	ИначеЕсли СтрНачинаетсяС(КомандаПриложения, "account:") Тогда
		
		ОткрытьОтчетПоСчету(Сред(КомандаПриложения, СтрДлина("account:") + 1));
		
	ИначеЕсли КомандаПриложения = "back" Тогда
		
		Если РежимАналитики = "Категория" Тогда
			
			СформироватьСводныйОтчетНаСервере();
			
		Иначе
			
			ПоказатьГлавнуюСтраницу();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьГлавнуюСтраницу()
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаОсновная;
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСтраницуМеню()
	
	СформироватьСтраницуМенюНаСервере();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаАналитика;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСтраницуМенюНаСервере()
	
	РежимАналитики = "Меню";
	ТекстHTMLАналитики = СобратьHTMLСтраницыСправочников();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСтраницуОтчетов()
	
	СформироватьСтраницуОтчетовНаСервере();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаАналитика;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСтраницуОтчетовНаСервере()
	
	РежимАналитики = "Отчеты";
	ТекстHTMLАналитики = СобратьHTMLСтраницыОтчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСтраницуОпераций()
	
	СформироватьСтраницуОперацийНаСервере();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаАналитика;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСтраницуОперацийНаСервере()
	
	РежимАналитики = "Операции";
	ТекстHTMLАналитики = СобратьHTMLСтраницыОпераций();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСтраницуНастроек()
	
	СформироватьСтраницуНастроекНаСервере();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаАналитика;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСтраницуНастроекНаСервере()
	
	РежимАналитики = "Настройки";
	ТекстHTMLАналитики = СобратьHTMLСтраницыНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВыборОперации()
	
	СформироватьВыборОперацииНаСервере();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаАналитика;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьВыборОперацииНаСервере()
	
	РежимАналитики = "FAB";
	ТекстHTMLАналитики = СобратьHTMLВыбораОперации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетПоКоду(КодОтчета)
	
	Если КодОтчета = "rashod" Тогда
		
		ОткрытьОтчетПоКатегориям(Истина);
		
	ИначеЕсли КодОтчета = "dohod" Тогда
		
		ОткрытьОтчетПоКатегориям(Ложь);
		
	ИначеЕсли КодОтчета = "accounts" Тогда
		
		ОткрытьОтчетПоСчетам();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетПоКатегориям(ВидОперацииРасход)
	
	ПараметрыОтчета = ПараметрыОтчетаЗаМесяц();
	ИмяФормыОтчета = ?(ВидОперацииРасход,
		"Отчет.ОтчетПоРасходам.Форма.ФормаОтчета",
		"Отчет.ОтчетПоДоходам.Форма.ФормаОтчета");
	
	ОткрытьФорму(ИмяФормыОтчета, ПараметрыОтчета, ЭтотОбъект, , , , ,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетПоСчетам()
	
	ПараметрыОтчета = ПараметрыОтчетаЗаМесяц();
	ПараметрыОтчета.Вставить("Счет", ПустаяСсылкаСчета());
	
	ОткрытьФорму("Отчет.ОтчетПоВзаиморасчетам.Форма.ФормаОтчета", ПараметрыОтчета, ЭтотОбъект, , , , ,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыОтчетаЗаМесяц()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыОтчета.Вставить("НачалоПериода", НачалоМесяца(ТекущаяДата()));
	ПараметрыОтчета.Вставить("КонецПериода", КонецМесяца(ТекущаяДата()));
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьПунктМеню(КодПункта)
	
	Если КодПункта = "accounts" Тогда
		
		ОткрытьФорму("Справочник.Счета.ФормаСписка", , ЭтотОбъект, , , , ,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	ИначеЕсли КодПункта = "contacts" Тогда
		
		ОткрытьФорму("Справочник.Контакты.ФормаСписка", , ЭтотОбъект, , , , ,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	ИначеЕсли КодПункта = "categories-income" Тогда
		
		ОткрытьФорму("Справочник.КатегорииДоходов.ФормаСписка", , ЭтотОбъект, , , , ,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	ИначеЕсли КодПункта = "categories-expense" Тогда
		
		ОткрытьФорму("Справочник.КатегорииРасходов.ФормаСписка", , ЭтотОбъект, , , , ,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	ИначеЕсли КодПункта = "currency" Тогда
		
		ОткрытьФорму("Справочник.Валюта.ФормаСписка", , ЭтотОбъект, , , , ,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	ИначеЕсли КодПункта = "doc-income" Тогда
		
		ОткрытьФорму("Документ.Доходы.ФормаСписка", , ЭтотОбъект, , , , ,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	ИначеЕсли КодПункта = "doc-expense" Тогда
		
		ОткрытьФорму("Документ.Расход.ФормаСписка", , ЭтотОбъект, , , , ,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	ИначеЕсли КодПункта = "doc-transfer" Тогда
		
		ОткрытьФорму("Документ.Переводы.ФормаСписка", , ЭтотОбъект, , , , ,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	ИначеЕсли КодПункта = "doc-debt" Тогда
		
		ОткрытьФорму("Документ.ПередачаСредствВДолг.ФормаСписка", , ЭтотОбъект, , , , ,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	ИначеЕсли КодПункта = "constants" Тогда
		
		ОткрытьФорму("ОбщаяФорма.ФормаКонстант", , ЭтотОбъект, , , , ,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСтраницуВсехСчетов()
	
	СформироватьСтраницуСчетовНаСервере();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаАналитика;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСтраницуСчетовНаСервере()
	
	РежимАналитики = "Счета";
	ТекстHTMLАналитики = СобратьHTMLСтраницыВсехСчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСводныйОтчетПоПериоду(ИмяПериода)
	
	ВидПериодаОтчета = ИмяПериода;
	СформироватьСводныйОтчетНаСервере();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаАналитика;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРасшифровкуКатегории(КодВидаОперации, ИдентификаторКатегории)
	
	ВидОперацииРасходРасшифровки = (КодВидаОперации = "rashod");
	КатегорияРасшифровки = КатегорияПоИдентификатору(ВидОперацииРасходРасшифровки, ИдентификаторКатегории);
	СформироватьРасшифровкуКатегорииНаСервере();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаАналитика;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСводныйОтчетНаСервере()
	
	ОбщийМодульСервер_Отчеты.УстановитьПериодПоВиду(ВидПериодаОтчета, НачалоПериодаОтчета, КонецПериодаОтчета);
	РежимАналитики = "Операции";
	ТекстHTMLАналитики = ОбщийМодульСервер_Отчеты.HTMLСводногоОтчетаПоОперациям(
		НачалоПериодаОтчета, КонецПериодаОтчета, ВидПериодаОтчета);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьРасшифровкуКатегорииНаСервере()
	
	РежимАналитики = "Категория";
	ТекстHTMLАналитики = ОбщийМодульСервер_Отчеты.HTMLРасшифровкиПоДням(
		ВидОперацииРасходРасшифровки, КатегорияРасшифровки, НачалоПериодаОтчета, КонецПериодаОтчета, ВидПериодаОтчета);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьРасшифровкуПослеСменыПериодаНаСервере()
	
	ОбщийМодульСервер_Отчеты.УстановитьПериодПоВиду(ВидПериодаОтчета, НачалоПериодаОтчета, КонецПериодаОтчета);
	СформироватьРасшифровкуКатегорииНаСервере();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КатегорияПоИдентификатору(ВидОперацииРасход, ИдентификаторКатегории)
	
	Если Не ЗначениеЗаполнено(ИдентификаторКатегории) Тогда
		
		Если ВидОперацииРасход Тогда
			
			Возврат Справочники.КатегорииРасходов.ПустаяСсылка();
			
		КонецЕсли;
		
		Возврат Справочники.КатегорииДоходов.ПустаяСсылка();
		
	КонецЕсли;
	
	Идентификатор = Новый УникальныйИдентификатор(ИдентификаторКатегории);
	
	Если ВидОперацииРасход Тогда
		
		Возврат Справочники.КатегорииРасходов.ПолучитьСсылку(Идентификатор);
		
	КонецЕсли;
	
	Возврат Справочники.КатегорииДоходов.ПолучитьСсылку(Идентификатор);
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуБыстрогоВвода(ИмяВидаОперации)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияФормыДокумента", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ОбщаяФормаДокумента",
		Новый Структура("ВидОперации", ПолучитьВидОперации(ИмяВидаОперации)),
		ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПеревода()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияФормыПеревода", ЭтотОбъект);
	ОткрытьФорму("Документ.Переводы.Форма.ФормаДокумента", , ЭтотОбъект, , , , ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуДолга()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияФормыПеревода", ЭтотОбъект);
	ОткрытьФорму("Документ.ПередачаСредствВДолг.Форма.ФормаДокумента", , ЭтотОбъект, , , , ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыПеревода(Результат, ПараметрыРезультата) Экспорт
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Функция ИзвлечьКомандуИзСсылки(Знач АдресСсылки)
	
	Если Не ЗначениеЗаполнено(АдресСсылки) Тогда
		
		Возврат "";
		
	КонецЕсли;
	
	АдресСсылки = СокрЛП(Строка(АдресСсылки));
	Маркер = "app:";
	Позиция = СтрНайти(АдресСсылки, Маркер);
	
	Если Позиция = 0 Тогда
		
		Возврат "";
		
	КонецЕсли;
	
	КомандаПриложения = Сред(АдресСсылки, Позиция + СтрДлина(Маркер));
	ПозицияПараметров = СтрНайти(КомандаПриложения, "?");
	
	Если ПозицияПараметров > 0 Тогда
		
		КомандаПриложения = Лев(КомандаПриложения, ПозицияПараметров - 1);
		
	КонецЕсли;
	
	ПозицияЯкоря = СтрНайти(КомандаПриложения, "#");
	
	Если ПозицияЯкоря > 0 Тогда
		
		КомандаПриложения = Лев(КомандаПриложения, ПозицияЯкоря - 1);
		
	КонецЕсли;
	
	Возврат КомандаПриложения;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьОтчетПоСчету(ИдентификаторСчетаСтрокой)
	
	Счет = НайтиСчетПоИдентификатору(ИдентификаторСчетаСтрокой);
	
	Если Не ЗначениеЗаполнено(Счет) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыОтчета.Вставить("Счет", Счет);
	ПараметрыОтчета.Вставить("НачалоПериода", НачалоДня(ТекущаяДата()));
	ПараметрыОтчета.Вставить("КонецПериода", КонецДня(ТекущаяДата()));
	
	ОткрытьФорму("Отчет.ОтчетПоВзаиморасчетам.Форма.ФормаОтчета", ПараметрыОтчета, ЭтотОбъект, , , , ,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаСервере
Функция НайтиСчетПоИдентификатору(ИдентификаторСчетаСтрокой)
	
	Возврат Справочники.Счета.ПолучитьСсылку(Новый УникальныйИдентификатор(ИдентификаторСчетаСтрокой));
	
КонецФункции

&НаСервереБезКонтекста
Функция ПустаяСсылкаСчета()
	
	Возврат Справочники.Счета.ПустаяСсылка();
	
КонецФункции

&НаСервере
Функция ПолучитьВидОперации(ВидОперации)
	
	Возврат Перечисления.ВидОперацииДокумента[ВидОперации];
	
КонецФункции

#КонецОбласти
