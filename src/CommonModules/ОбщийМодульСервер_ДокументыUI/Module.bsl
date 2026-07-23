////////////////////////////////////////////////////////////////////////////////
// HTML-формы документов дохода и расхода (Wallet).
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Собирает HTML формы документа дохода или расхода по макету Wallet.
// Данные: Дата, Счет, Категория, Сумма, Комментарий, Заголовок.
//
Функция HTMLФормыДоходаРасхода(ЭтоРасход, Данные) Экспорт
	
	Акцент = ?(ЭтоРасход, "#DC2626", "#16A34A");
	ФонИнфо = ?(ЭтоРасход, "#FEF2F2", "#F0FDF4");
	ЦветИнфо = ?(ЭтоРасход, "#991B1B", "#166534");
	ЦветИнфоИконки = ?(ЭтоРасход, "#DC2626", "#16A34A");
	ПодписьСчета = ?(ЭтоРасход, "Счет списания", "Счет зачисления");
	ПодписьСуммы = ?(ЭтоРасход, "Сумма расхода", "Сумма дохода");
	ПодписьПосле = ?(ЭтоРасход, "После расхода", "После дохода");
	ПодписьКнопки = ?(ЭтоРасход, "Добавить расход", "Добавить доход");
	КлассКнопки = ?(ЭтоРасход, "submit expense", "submit income");
	
	ДанныеСчета = ДанныеСчетаДляОперации(Данные.Счет);
	ДанныеКатегории = ОбщийМодульСервер_Категории.ДанныеОтображенияКатегории(ЭтоРасход, Данные.Категория);
	
	Сумма = ?(ЗначениеЗаполнено(Данные.Сумма), Данные.Сумма, 0);
	СуммаТекст = ОбщийМодульСервер_КурсыВалют.ПредставлениеСуммыВВалютеУчетаДляHTML(Сумма, Ложь);
	
	Если Сумма <= 0 Тогда
		
		СуммаТекст = "0&nbsp;" + ЭкранироватьHTML(ОбщийМодульСервер_КурсыВалют.СимволВалюты(
			ОбщийМодульСервер_СистемныеНастройки.ПолучитьВалютуРегламентированногоУчета()));
		
	КонецЕсли;
	
	ОстатокПосле = ДанныеСчета.Остаток + ?(ЭтоРасход, -Сумма, Сумма);
	ОстатокПослеТекст = ОбщийМодульСервер_КурсыВалют.ПредставлениеСуммыВВалютеУчетаДляHTML(ОстатокПосле, Ложь);
	ОстатокТекст = ОбщийМодульСервер_КурсыВалют.ПредставлениеСуммыВВалютеУчетаДляHTML(ДанныеСчета.Остаток, Ложь);
	
	КлассСчета = ?(ДанныеСчета.Заполнен, "", "placeholder");
	КлассКатегории = ?(ДанныеКатегории.Заполнена, "", "placeholder");
	
	ТекстДаты = ?(ЗначениеЗаполнено(Данные.Дата), Формат(Данные.Дата, "ДФ='d MMMM yyyy, HH:mm'"), "Выберите дату");
	КлассДаты = ?(ЗначениеЗаполнено(Данные.Дата), "", "placeholder");
	
	Комментарий = СокрЛП(Данные.Комментарий);
	ДлинаКомментария = СтрДлина(Комментарий);
	ТекстКомментария = ?(ПустаяСтрока(Комментарий), "Добавить комментарий", Комментарий);
	КлассКомментария = ?(ПустаяСтрока(Комментарий), "placeholder", "");
	
	МожноЗаписать = ДанныеСчета.Заполнен И ДанныеКатегории.Заполнена И Сумма > 0;
	
	Строки = Новый Массив;
	Строки.Добавить("<!DOCTYPE html><html lang=""ru""><head><meta charset=""utf-8"">");
	Строки.Добавить("<meta name=""viewport"" content=""width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"">");
	Строки.Добавить("<style>" + СтилиФормыОперации(Акцент) + "</style></head><body>");
	
	Строки.Добавить("<div class=""top"">");
	Строки.Добавить("<a class=""icon-btn"" href=""app:back"">" + SVGСтрелкаНазад() + "</a>");
	Строки.Добавить("<div class=""title"">" + ЭкранироватьHTML(Данные.Заголовок) + "</div>");
	Строки.Добавить("<a class=""icon-btn"" href=""app:history"">" + SVGИстория() + "</a></div>");
	
	Строки.Добавить("<div class=""lbl"">" + ЭкранироватьHTML(ПодписьСчета) + "</div>");
	Строки.Добавить("<a class=""card account"" href=""app:account"">");
	Строки.Добавить("<span class=""acc-ico"" style=""background:#EFF6FF;color:#2563EB"">" + SVGКарта() + "</span>");
	Строки.Добавить("<span class=""acc-mid""><span class=""acc-name " + КлассСчета + """>"
		+ ЭкранироватьHTML(ДанныеСчета.Наименование) + "</span>");
	Строки.Добавить("<span class=""acc-sub"">" + ЭкранироватьHTML(ДанныеСчета.Подпись) + "</span></span>");
	Строки.Добавить("<span class=""acc-right""><span class=""acc-sum"">" + ОстатокТекст + "</span>"
		+ "<span class=""chev"">›</span></span></a>");
	
	Строки.Добавить("<div class=""lbl"">Категория</div>");
	Строки.Добавить("<a class=""card account"" href=""app:category"">");
	Строки.Добавить("<span class=""acc-ico"" style=""background:" + ДанныеКатегории.ФонИконки + ";color:"
		+ ДанныеКатегории.ЦветИконки + """>" + ДанныеКатегории.SVG + "</span>");
	Строки.Добавить("<span class=""acc-mid""><span class=""acc-name " + КлассКатегории + """>"
		+ ЭкранироватьHTML(ДанныеКатегории.Наименование) + "</span>");
	Строки.Добавить("<span class=""acc-sub"">" + ЭкранироватьHTML(ДанныеКатегории.Описание) + "</span></span>");
	Строки.Добавить("<span class=""acc-right""><span class=""chev alone"">›</span></span></a>");
	
	Строки.Добавить("<div class=""card amount-card"">");
	Строки.Добавить("<div class=""amount-head""><div class=""lbl"">" + ЭкранироватьHTML(ПодписьСуммы)
		+ "</div><a class=""clear"" href=""app:clear-sum"">" + SVGОчистить() + "</a></div>");
	Строки.Добавить("<a class=""amount"" style=""color:" + Акцент + """ href=""app:edit-sum"">" + СуммаТекст + "</a>");
	Строки.Добавить("<div class=""chips"">");
	СимволВалюты = ЭкранироватьHTML(ОбщийМодульСервер_КурсыВалют.СимволВалюты(
		ОбщийМодульСервер_СистемныеНастройки.ПолучитьВалютуРегламентированногоУчета()));
	
	Если ЭтоРасход Тогда
		
		Строки.Добавить("<a class=""chip"" href=""app:add:500"">+500&nbsp;" + СимволВалюты + "</a>");
		Строки.Добавить("<a class=""chip"" href=""app:add:1000"">+1&nbsp;000&nbsp;" + СимволВалюты + "</a>");
		Строки.Добавить("<a class=""chip"" href=""app:add:5000"">+5&nbsp;000&nbsp;" + СимволВалюты + "</a>");
		
	Иначе
		
		Строки.Добавить("<a class=""chip"" href=""app:add:10000"">+10&nbsp;000&nbsp;" + СимволВалюты + "</a>");
		Строки.Добавить("<a class=""chip"" href=""app:add:50000"">+50&nbsp;000&nbsp;" + СимволВалюты + "</a>");
		Строки.Добавить("<a class=""chip"" href=""app:add:100000"">+100&nbsp;000&nbsp;" + СимволВалюты + "</a>");
		
	КонецЕсли;
	
	Строки.Добавить("<a class=""chip"" href=""app:other-sum"">Другая</a></div></div>");
	
	Строки.Добавить("<a class=""card field"" href=""app:date"">");
	Строки.Добавить("<div class=""field-mid""><div class=""lbl"">Дата и время</div>");
	Строки.Добавить("<div class=""field-val " + КлассДаты + """>" + ЭкранироватьHTML(ТекстДаты) + "</div></div>");
	Строки.Добавить("<div class=""field-ico"">" + SVGКалендарь() + "</div></a>");
	
	Строки.Добавить("<a class=""card comment"" href=""app:edit-comment"">");
	Строки.Добавить("<div class=""comment-head""><div class=""lbl"">Комментарий</div>");
	Строки.Добавить("<div class=""counter"">" + Формат(ДлинаКомментария, "ЧН=0; ЧГ=") + "/100</div></div>");
	Строки.Добавить("<div class=""field-val " + КлассКомментария + """>" + ЭкранироватьHTML(ТекстКомментария) + "</div>");
	Строки.Добавить("</a>");
	
	Если ДанныеСчета.Заполнен И Сумма > 0 Тогда
		
		Строки.Добавить("<div class=""info"" style=""background:" + ФонИнфо + ";color:" + ЦветИнфо + """>");
		Строки.Добавить("<span class=""info-ico"" style=""background:" + ЦветИнфоИконки + """>"
			+ ?(ЭтоРасход, "!", "i") + "</span>");
		Строки.Добавить("<span> " + ЭкранироватьHTML(ПодписьПосле) + ": "
			+ ЭкранироватьHTML(ДанныеСчета.Наименование) + " " + ОстатокПослеТекст + "</span></div>");
		
	КонецЕсли;
	
	Строки.Добавить("<div class=""actions"">");
	
	Если МожноЗаписать Тогда
		
		Строки.Добавить("<a class=""" + КлассКнопки + """ href=""app:submit"">"
			+ ?(ЭтоРасход, SVGКорзинаКнопки(), SVGПлюсКнопки()) + "<span>"
			+ ЭкранироватьHTML(ПодписьКнопки) + " " + СуммаТекст + "</span></a>");
		
	Иначе
		
		Строки.Добавить("<a class=""submit disabled"" href=""app:noop"">Заполните обязательные поля</a>");
		
	КонецЕсли;
	
	Строки.Добавить("</div>");
	Строки.Добавить(HTMLНижняяНавигация());
	Строки.Добавить("</body></html>");
	
	Возврат СтрСоединить(Строки, Символы.ПС);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеСчетаДляОперации(Счет)
	
	Результат = Новый Структура;
	Результат.Вставить("Заполнен", Ложь);
	Результат.Вставить("Наименование", "Выберите счёт");
	Результат.Вставить("Подпись", "Счёт операции");
	Результат.Вставить("Остаток", 0);
	
	Если Не ЗначениеЗаполнено(Счет) Тогда
		
		Возврат Результат;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Кошелек.Наименование КАК Наименование,
	|	Кошелек.ВидСчета КАК ВидСчета,
	|	ЕСТЬNULL(БалансОстатки.СуммаОстаток, 0) КАК Остаток
	|ИЗ
	|	Справочник.Счета КАК Кошелек
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Баланс.Остатки(&Период, Счета = &Счет) КАК БалансОстатки
	|		ПО ИСТИНА
	|ГДЕ
	|	Кошелек.Ссылка = &Счет";
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Результат.Заполнен = Истина;
		Результат.Наименование = Выборка.Наименование;
		Результат.Подпись = ПредставлениеВидаСчета(Выборка.ВидСчета);
		Результат.Остаток = Выборка.Остаток;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПредставлениеВидаСчета(ВидСчета)
	
	Если ВидСчета = Перечисления.ВидСчета.Кошелек Тогда
		
		Возврат "Наличные";
		
	ИначеЕсли ВидСчета = Перечисления.ВидСчета.БанковскаяКарта Тогда
		
		Возврат "Банковская карта";
		
	ИначеЕсли ВидСчета = Перечисления.ВидСчета.БанковскийСчет Тогда
		
		Возврат "Банковский счёт";
		
	КонецЕсли;
	
	Возврат "Счёт";
	
КонецФункции

Функция СтилиФормыОперации(Акцент)
	
	Возврат "*{box-sizing:border-box;margin:0;padding:0;-webkit-tap-highlight-color:transparent}"
		+ "body{font-family:-apple-system,BlinkMacSystemFont,""Segoe UI"",Roboto,Arial,sans-serif;background:#FAFAFA;"
		+ "color:#111827;padding:12px 16px 160px;line-height:1.3}"
		+ "a{text-decoration:none;color:inherit;-webkit-user-select:none;user-select:none}"
		+ ".top{display:flex;align-items:center;justify-content:space-between;margin-bottom:14px}"
		+ ".title{font-size:18px;font-weight:700;color:#111827}"
		+ ".icon-btn{width:36px;height:36px;border-radius:50%;background:#F3F4F6;display:flex;align-items:center;"
		+ "justify-content:center;color:#6B7280}"
		+ ".lbl{font-size:12px;font-weight:600;color:#6B7280;margin:0 0 6px 2px}"
		+ ".card{display:block;background:#fff;border:1px solid #E5E7EB;border-radius:16px;padding:14px;margin-bottom:10px}"
		+ ".account{display:flex;align-items:center}"
		+ ".acc-ico{width:40px;height:40px;border-radius:12px;flex-shrink:0;display:flex;align-items:center;"
		+ "justify-content:center;margin-right:12px}"
		+ ".acc-ico svg{width:20px;height:20px}"
		+ ".acc-mid{flex:1;min-width:0}"
		+ ".acc-name{display:block;font-size:15px;font-weight:700;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}"
		+ ".acc-name.placeholder,.field-val.placeholder{color:#9CA3AF;font-weight:500}"
		+ ".acc-sub{display:block;margin-top:2px;font-size:12px;color:#6B7280}"
		+ ".acc-right{text-align:right;flex-shrink:0;margin-left:10px}"
		+ ".acc-sum{display:block;font-size:14px;font-weight:700}"
		+ ".chev{display:block;margin-top:2px;font-size:16px;color:#9CA3AF}"
		+ ".chev.alone{margin-top:0}"
		+ ".amount-card .amount-head{display:flex;align-items:center;justify-content:space-between}"
		+ ".amount-card .lbl{margin:0}"
		+ ".amount{display:block;font-size:32px;font-weight:700;letter-spacing:-0.02em;margin:8px 0 12px}"
		+ ".clear{width:28px;height:28px;border-radius:50%;background:#F3F4F6;display:flex;align-items:center;"
		+ "justify-content:center;color:#9CA3AF}"
		+ ".chips{display:flex;flex-wrap:wrap}"
		+ ".chip{display:inline-flex;align-items:center;justify-content:center;padding:8px 12px;border-radius:12px;"
		+ "background:#EFF6FF;border:1px solid #BFDBFE;font-size:13px;font-weight:600;color:#2563EB;margin:0 8px 0 0}"
		+ ".field{display:flex;align-items:center}"
		+ ".field-mid{flex:1;min-width:0}"
		+ ".field-val{font-size:15px;font-weight:700;color:#111827}"
		+ ".field-ico{width:28px;height:28px;border-radius:8px;background:#F3F4F6;color:#9CA3AF;display:flex;"
		+ "align-items:center;justify-content:center;flex-shrink:0;margin-left:10px}"
		+ ".comment-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:6px}"
		+ ".comment .lbl{margin:0}"
		+ ".comment .field-val{font-weight:600;white-space:pre-wrap}"
		+ ".counter{font-size:12px;color:#9CA3AF;font-weight:600}"
		+ ".info{display:flex;align-items:center;border-radius:12px;padding:10px 12px;margin:4px 0 12px;"
		+ "font-size:13px;font-weight:600}"
		+ ".info-ico{width:18px;height:18px;border-radius:50%;color:#fff;display:inline-flex;align-items:center;"
		+ "justify-content:center;font-size:11px;font-weight:700;flex-shrink:0;margin-right:8px}"
		+ ".actions{position:fixed;left:0;right:0;bottom:58px;padding:10px 16px;"
		+ "background:linear-gradient(180deg,rgba(250,250,250,0),#FAFAFA 28%);z-index:11}"
		+ ".submit{display:flex;align-items:center;justify-content:center;border-radius:14px;padding:14px 16px;"
		+ "font-size:16px;font-weight:700}"
		+ ".submit svg{margin-right:8px;flex-shrink:0}"
		+ ".submit.expense{background:#2563EB;color:#fff;box-shadow:0 6px 16px rgba(37,99,235,0.28)}"
		+ ".submit.income{background:#fff;color:" + Акцент + ";border:2px solid " + Акцент + "}"
		+ ".submit.disabled{background:#E5E7EB;color:#9CA3AF;box-shadow:none;border:none}"
		+ ".nav{position:fixed;left:0;right:0;bottom:0;background:#fff;border-top:1px solid #E5E7EB;display:flex;"
		+ "padding:6px 2px calc(6px + env(safe-area-inset-bottom,0px));z-index:12}"
		+ ".nav a{flex:1;text-align:center;padding:4px 1px;color:#6B7280;font-size:9px;font-weight:600;line-height:1.15}"
		+ ".nav .ico{height:18px;display:flex;align-items:center;justify-content:center;margin-bottom:2px}"
		+ ".nav .ico svg{display:block;width:18px;height:18px}"
		+ ".nav a.active{color:#2563EB}";
	
КонецФункции

Функция HTMLНижняяНавигация()
	
	Возврат "<nav class=""nav"">"
		+ "<a href=""app:home""><span class=""ico"">" + SVGДом() + "</span>Главная</a>"
		+ "<a class=""active"" href=""app:operations""><span class=""ico"">" + SVGОперации() + "</span>Операции</a>"
		+ "<a href=""app:reports""><span class=""ico"">" + SVGДиаграмма() + "</span>Отчёты</a>"
		+ "<a href=""app:catalogs""><span class=""ico"">" + SVGПапка() + "</span>Справочники</a>"
		+ "<a href=""app:settings""><span class=""ico"">" + SVGНастройки() + "</span>Настройки</a>"
		+ "</nav>";
	
КонецФункции

Функция ЭкранироватьHTML(Знач Текст)
	
	Результат = Строка(Текст);
	Результат = СтрЗаменить(Результат, "&", "&amp;");
	Результат = СтрЗаменить(Результат, "<", "&lt;");
	Результат = СтрЗаменить(Результат, ">", "&gt;");
	Результат = СтрЗаменить(Результат, """", "&quot;");
	
	Возврат Результат;
	
КонецФункции

Функция SVGСтрелкаНазад()
	
	Возврат "<svg width=""18"" height=""18"" viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""><path d=""M15 18l-6-6 6-6""/></svg>";
	
КонецФункции

Функция SVGИстория()
	
	Возврат "<svg width=""18"" height=""18"" viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""><path d=""M3 12a9 9 0 1 0 3-6.7""/><path d=""M3 4v5h5""/><path d=""M12 7v5l3 2""/></svg>";
	
КонецФункции

Функция SVGКарта()
	
	Возврат "<svg width=""20"" height=""20"" viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""><rect x=""2"" y=""5"" width=""20"" height=""14"" rx=""2""/><path d=""M2 10h20""/></svg>";
	
КонецФункции

Функция SVGОчистить()
	
	Возврат "<svg width=""14"" height=""14"" viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2.5"" stroke-linecap=""round""><path d=""M18 6L6 18""/><path d=""M6 6l12 12""/></svg>";
	
КонецФункции

Функция SVGКалендарь()
	
	Возврат "<svg width=""16"" height=""16"" viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""><rect x=""3"" y=""4"" width=""18"" height=""18"" rx=""2""/><path d=""M16 2v4""/><path d=""M8 2v4""/><path d=""M3 10h18""/></svg>";
	
КонецФункции

Функция SVGКорзинаКнопки()
	
	Возврат "<svg width=""18"" height=""18"" viewBox=""0 0 24 24"" fill=""none"" stroke=""#FCA5A5"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""><circle cx=""9"" cy=""20"" r=""1""/><circle cx=""17"" cy=""20"" r=""1""/><path d=""M3 3h2l2 12h10l2-8H7""/></svg>";
	
КонецФункции

Функция SVGПлюсКнопки()
	
	Возврат "<svg width=""18"" height=""18"" viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2.5"" stroke-linecap=""round""><path d=""M12 5v14""/><path d=""M5 12h14""/></svg>";
	
КонецФункции

Функция SVGДом()
	
	Возврат "<svg viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""><path d=""M3 10.5L12 3l9 7.5""/><path d=""M5 9.5V20h14V9.5""/></svg>";
	
КонецФункции

Функция SVGОперации()
	
	Возврат "<svg viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""><path d=""M7 7h11l-3-3""/><path d=""M17 17H6l3 3""/><path d=""M6 12h12""/></svg>";
	
КонецФункции

Функция SVGДиаграмма()
	
	Возврат "<svg viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""><path d=""M4 19h16""/><path d=""M7 16V9""/><path d=""M12 16V5""/><path d=""M17 16v-3""/></svg>";
	
КонецФункции

Функция SVGПапка()
	
	Возврат "<svg viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""><path d=""M3 7h6l2 2h10v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V7z""/></svg>";
	
КонецФункции

Функция SVGНастройки()
	
	Возврат "<svg viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""><circle cx=""12"" cy=""12"" r=""3""/><path d=""M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4""/></svg>";
	
КонецФункции

#КонецОбласти
