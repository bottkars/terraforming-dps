aws ec2 describe-images --owners 679593333241 --filters "Name=name,Values=ddve*" --output table --query 'Images[*].{Name:Name,Description:Description}'
aws ec2 describe-images --owners 679593333241 --filters "Name=name,Values=ppdm*" --output table --query 'Images[*].{Name:Name,Description:Description}'
