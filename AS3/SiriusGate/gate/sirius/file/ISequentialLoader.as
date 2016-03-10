package gate.sirius.file {
	import flash.errors.IOError;
	import flash.system.LoaderContext;
	import gate.sirius.file.signals.ILoaderSignals;
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public interface ISequentialLoader {
		
		/**
		 * On file load start
		 */
		function get signals():ILoaderSignals;
		
		/**
		 * Progresso do carregamento de todos os arquivos
		 */
		function get loadCircleProgress():Number;
		
		/**
		 * Total de arquivos
		 */
		function get length():int;
		
		/**
		 * Contagem de arquivos carregados
		 */
		function get loadedFiles():int;
		
		/**
		 * Arquivo atual
		 */
		function get currentFile():IFileInfo;
		
		/**
		 * Indica se todos os arquivos foram carregados
		 */
		function get isComplete():Boolean;
		
		/**
		 * Progress of the current load
		 */
		function get currentFileProgress():Number;
		
		/**
		 * List of the names of added files
		 */
		function get fileNames():Vector.<String>;
		
		/**
		 * Inicia o ciclo de carregamento
		 */
		function start(context:LoaderContext = null):void;
		
		/**
		 * Para o cicle de carregamento
		 */
		function stop():void;
		
		/**
		 * Remove um arquivo previamente carregado
		 * @param	name
		 */
		function clear(name:String = null, dispose:Boolean = true):void;
		
		/**
		 * Adiciona um arquivo
		 * @param	name
		 * @param	url
		 */
		function addFile(name:String, url:*, type:String = "auto", extra:Object = null):IFileInfo;
		
		/**
		 * Retorna um arquivo pelo nome
		 * @param	name
		 * @return
		 */
		function getFileByName(name:String):IFileInfo;
		
		/**
		 * Verifica existencia de um arquivo
		 * @param	name
		 * @return
		 */
		function hasFile(name:String):Boolean;
		
		/**
		 * Verifica existencia de um conteúdo
		 * @param	name
		 * @return
		 */
		function hasContent(name:String):Boolean;
		
		/**
		 * Retorna arquivos carregados
		 * @return
		 */
		function getLoadedFiles():Vector.<IFileInfo>;
		
		/**
		 * Filtra todos os arquivos por uma classe especifica
		 * @param	Filter
		 * @return
		 */
		function getFilesByClass(Filter:Class):Array;
		
		/**
		 * List of all files data
		 */
		function getFilesInfo():Vector.<IFileInfo>;
		
		/**
		 * Clear instance memory
		 */
		function dispose():void;
		
		/**
		 * Total of loaded bytes
		 */
		function get totalBytes():int;
	}
}
