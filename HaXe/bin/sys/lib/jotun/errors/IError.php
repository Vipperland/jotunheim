<?php
/**
 */

namespace jotun\errors;

use \php\Boot;

/**
 * @author Rafael Moreira
 */
interface IError {
}

Boot::registerClass(IError::class, 'jotun.errors.IError');
