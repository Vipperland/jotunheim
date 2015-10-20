<?php
	
	require_once('class.pop3.php');
	require_once('class.smtp.php');
	require_once('class.phpmailer.php');
	
	header('content-type: application/json; charset=utf-8');
	
	class Form {
		
		private $_current;
		
		public function __construct() {
		}
		
		function doResult($value) {
			print json_encode($value, 256);
		}	
		
		public function send($shield = true) {
			
			$name = @$_REQUEST['name'];
			$email = @$_REQUEST['email'];
			$subject = @$_REQUEST['subject'];
			$message = @$_REQUEST['message'];
			$antispam = $shield || @$_REQUEST['foobar'] == "";
			
			$result = new \stdClass();
			
			if ($antispam) {
				
				if ($name != null && $email != null && $message != null) {
					
					$mail = new \PHPMailer();
					$mail->IsSMTP();
					$mail->SMTPAuth   = true;
					
					//$mail->Host       = "smtp100k1.ipreverso.com";
					$mail->SMTPDebug  = isset($_REQUEST['debug']) && !empty($_REQUEST['debug']) ? $_REQUEST['debug'] : 0;
					$mail->CharSet = 'UTF-8';
					
					$mail->SMTPSecure = "tls";
					$mail->Host       = "smtp.gmail.com";
					$mail->Port       = 587;
					$mail->Username   = "";
					$mail->Password   = "";
					
					$mail->From = "coldzone@gmail.com";
					$mail->FromName = "Rafael Moreira";
					
					
					$mail->addAddress("coldzone@gmail.com");
					
					//$mail->AddBCC("coldzone@gmail.com", "Rafael Moreira");
					$mail->addReplyTo($email, $name);
					
					$mail->Subject = $subject;
					$mail->MsgHTML("<b>" . $name . "</b> say:<br/>" . $message);
					$mail->IsHTML(true);
					
					if(isset($_FILES['uploaded_file'])){
						$file_tmp = $_FILES['uploaded_file']['tmp_name'];
						if (is_uploaded_file($file_tmp)) {
							$file_size = $_FILES['uploaded_file']['size'];
							$file_name = $_FILES['uploaded_file']['name'];
							move_uploaded_file($file_tmp, '/dev/public/'.$file_name); 
							$mail->AddAttachment('/dev/public/'.$file_name, $file_name);
							$result->attachment = $file_name;
						}else {
							$result->attachment = "none";
						}	
					}
					
					if ($mail->send()) {
						$result->success = true;
						$result->message = "form.mail.sent";
					}else {
						$result->success = false;
						$result->message = "form.mail.unsent";
						$result->error = $mail->ErrorInfo;
					}	
					
				}else {
					$result->success = false;
					$result->message = "form.fields.missing";
					$result->fields = "name,email,message";
				}	
				
			}else {
				$result->success = false;
				$result->message = "form.status.shield";
				$result->error = "Spam found, Email not sent";
			}
			$this->doResult($result);
		}
		
	}
	
	$form = new \Form();
	$form->send(false);
	

?>