<?php
/**
 */

namespace jotun\gaming\actions;

use \php\Boot;

/**
 * @author Rim Project
 */
interface IEventContext {
}

Boot::registerClass(IEventContext::class, 'jotun.gaming.actions.IEventContext');
