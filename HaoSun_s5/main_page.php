<!--Note: The session_start() function must be the very first thing in your document.
Before any HTML tags.-->
<?php
    session_start();
?>

<!DOCTYPE html>
    <html lang="en">
        <head>
            <title> File Sharing System </title>
            <link rel="stylesheet" type="text/css" href="style.css">
            <!--<style type="text/css">-->
            <!--    -->
            <!--    body{-->
            <!--        background: teal;-->
            <!--        font-family: arial;-->
            <!--        line-height: 1.5em;-->
            <!--    }-->
            <!--    #main{-->
            <!--        background-color: #f4f4f4;-->
            <!--        border:10px #cccccc solid;-->
            <!--        padding: 10px 10px 10px 10px;-->
            <!--        margin-top: 250px;-->
            <!--        width: 600px;-->
            <!--        margin: 30px auto;-->
            <!--    }-->
            <!--</style>-->
        </head>
        <body>
            <div id="main">
                <h1>Welcome to File Sharing System!</h1>
                
                <!--<form name="input" action="login_signup_page.php" method="POST">-->
                <!--    <label for="userName">User Name (No ~!@#$%^&*()):</label>-->
                <!--    <input type="text" name="userName">-->
                <!--    <input type="submit" name="Login" value="Login">-->
                <!--    <input type="submit" name="Signup" value="Signup">-->
                <!--</form>-->
                    
                <!--
                1. type in user name and press the login button, direct to login_signup_page.php
                2. type in user name and press the signup, direct to login_signup_page.php
                there are "login" and "signup" judgement in login_signup_page.php
                -->
                
                <fieldset>
                    <legend>Account:</legend>
                    <form action="<?php echo htmlentities($_SERVER['PHP_SELF']); ?>" method="POST">
                    <label for="userName">User Name:</label>
                    <input type="text" name="userName" />
                    <input type="submit" name="Check" value="Check User Name" />
                    <input type="submit" name="Login" value="Login" />
                    <input type="submit" name="Signup" value="Signup" />
                </form>
                </fieldset>
                
                
                <?php
                    //session_start();
                    //if user press check user name button
                    //give the information about whether the user name user just typed in exist
                    if(isset($_POST['Check'])){
                        
                        //check whether userName is set
                        if(isset($_POST['userName'])) {
                            //check users.txt file
                            $file = fopen("/srv/users.txt", "r"); 
                            $username = $_POST['userName'];
                            $isExist = false;
                            #check whether the username is in the file
                            // make sure username is valid
                            if (preg_match('/^[\w_\.\-]+$/', $username)) {   
                                while (!feof($file)) {
                                    //fgets reads the contents of a line, and trim() gets the value of fgets() for compare string
                                    if ($username == trim(fgets($file))) {      //find same user name
                                        $isExist = true;
                                        printf("<p><strong>%s already exists</strong></p>\n",
                                            htmlentities($_POST['userName']));
                                        fclose($file);
                                        exit;
                                    }
                                }
                                fclose($file);
                                
                                 //no same user name, the typed-in username canbe used to Signup
                                if($isExist == false){                                          
                                    printf("<p><strong>%s can be used</strong></p>\n",
                                            htmlentities($_POST['userName']));
                                        exit;
                                }
                            }
                            else{
                                if($username == ""){
                                    printf("<p><strong>Null user name</strong></p>\n");
                                    exit;
                                }
                                else{
                                    printf("<p><strong>%s is an invalid user name</strong></p>\n",
                                       htmlentities($_POST['userName']));
                                    exit;
                                }
                            }   
                        }
                        else{  //user name is not set
                            printf("<p><strong>Null user name</strong></p>\n");
                            exit;
                        }
                    }
                    //if user press login button
                    if(isset($_POST['Login'])){
                        //check whether userName is set
                        if(isset($_POST['userName'])) {
                            //check users.txt file
                            $file = fopen("/srv/users.txt", "r"); 
                            $username = $_POST['userName'];
                            $isExist = false;
                            #check whether the username is in the file
                            // make sure username is valid
                            if (preg_match('/^[\w_\.\-]+$/', $username)) {   
                                while (!feof($file)) {
                                    //fgets reads the contents of a line, and trim() gets the value of fgets() for compare string
                                    if ($username == trim(fgets($file))) {      //find same user name
                                        $isExist = true;
                                        $_SESSION['userName'] = $username;
                                        header("Location: user_page.php");
                                        fclose($file);
                                        exit;
                                    }
                                }
                                fclose($file);
                                
                                 //no same user name
                                if($isExist == false){                                          
                                    printf("<p><strong>%s is not exist</strong></p>\n",
                                            htmlentities($_POST['userName']));
                                        exit;
                                }
                            }
                            else{
                                if($username == ""){
                                    printf("<p><strong>Null user name</strong></p>\n");
                                    exit;
                                }
                                else{
                                    printf("<p><strong>%s is an invalid user name</strong></p>\n",
                                       htmlentities($_POST['userName']));
                                    exit;
                                }
                            }   
                        }
                        else{  //user name is not set
                            printf("<p><strong>Null user name</strong></p>\n");
                            exit;
                        }
                    }
                    
                    //if user press create button
                    if(isset($_POST['Signup'])){
                        //check whether userName is set
                        if(isset($_POST['userName'])) {
                            //check users.txt file
                            $file = fopen("/srv/users.txt", "r"); 
                            $username = $_POST['userName'];
                            $isExist = false;
                            #check whether the username is in the file
                            // make sure username is valid
                            if (preg_match('/^[\w_\.\-]+$/', $username)) {   
                                while (!feof($file)) {
                                    //fgets reads the contents of a line, and trim() gets the value of fgets() for compare string
                                    if ($username == trim(fgets($file))) {      //find same user name
                                        $isExist = true;
                                        printf("<p><strong>%s already exists</strong></p>\n",
                                            htmlentities($_POST['userName']));
                                        fclose($file);
                                        exit;
                                    }
                                }
                                fclose($file);
                                //no same user name, the typed-in username canbe used to Signup
                                //add this user name to users.txt and create dir
                                if($isExist == false){                                          
                                    $_SESSION['userName'] = $username;
                                    $file = "/srv/users.txt";
                                    //write this user to users.txt
                                    $current = file_get_contents($file);
                                    $current .= $username."\n";
                                    
                                    file_put_contents($file, $current);
                                    //create user dir
                                    
                                    header("Location: user_page.php");
                                    exit;
                                }
                            }
                            else{
                                if($username == ""){
                                    printf("<p><strong>Null user name</strong></p>\n");
                                    exit;
                                }
                                else{
                                    printf("<p><strong>%s is an invalid user name</strong></p>\n",
                                       htmlentities($_POST['userName']));
                                    exit;
                                }
                            }   
                        }
                        else{  //user name is not set
                            printf("<p><strong>Null user name</strong></p>\n");
                            exit;
                        }
                    }
                ?>
            </div>
        </body>
    </html>