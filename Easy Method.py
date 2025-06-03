from captcha.image import ImageCaptcha
from PIL import Image

# Create a CAPTCHA image generator with defined size
image = ImageCaptcha(width=300, height=100)

# Get text input from the user
captcha_text = input("Enter CAPTCHA text: ")

# Generate and save the CAPTCHA image
filename = 'CAPTCHA1.png'
image.write(captcha_text, filename)

# Open and display the image
img = Image.open(filename)
img.show()